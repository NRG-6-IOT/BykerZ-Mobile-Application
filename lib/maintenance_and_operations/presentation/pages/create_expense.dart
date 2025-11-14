import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/expense/expense_bloc.dart';
import '../../bloc/expense/expense_event.dart';
import '../../bloc/expense/expense_state.dart';
import '../../services/expense_service.dart';
import 'expenses.dart';

class CreateExpense extends StatelessWidget {
  const CreateExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseBloc(
        expenseService: ExpenseService(),
      ),
      child: const CreateExpenseView(),
    );
  }
}

class CreateExpenseView extends StatefulWidget {
  const CreateExpenseView({super.key});

  @override
  State<CreateExpenseView> createState() => _CreateExpenseViewState();
}

class _CreateExpenseViewState extends State<CreateExpenseView> with TickerProviderStateMixin {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemAmountController = TextEditingController();
  final TextEditingController _itemUnitPriceController = TextEditingController();

  String _selectedItemType = 'SUPPLIES';
  final List<String> _itemTypes = [
    'FINE',
    'PARKING',
    'PAYMENT',
    'SUPPLIES',
    'TAX',
    'TOOLS'
  ];

  List<Map<String, dynamic>> _items = [];
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _itemAmountController.text = '1';
    _itemUnitPriceController.text = '0';

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _headerController.forward();
  }

  double get _totalSum {
    return _items.fold(0.0, (sum, item) => sum + (item['totalPrice'] as double));
  }

  IconData _getItemTypeIcon(String type) {
    switch (type) {
      case 'FINE':
        return Icons.gavel_rounded;
      case 'PARKING':
        return Icons.local_parking_rounded;
      case 'PAYMENT':
        return Icons.payment_rounded;
      case 'SUPPLIES':
        return Icons.inventory_2_rounded;
      case 'TAX':
        return Icons.account_balance_rounded;
      case 'TOOLS':
        return Icons.build_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  void _addItem() {
    if (_itemNameController.text.trim().isEmpty ||
        _itemAmountController.text.isEmpty ||
        _itemUnitPriceController.text.isEmpty) {
      _showSnackBar('Please fill in all item fields', isError: true);
      return;
    }

    final amount = double.tryParse(_itemAmountController.text) ?? 0;
    final unitPrice = double.tryParse(_itemUnitPriceController.text) ?? 0;

    if (amount <= 0 || unitPrice < 0) {
      _showSnackBar('Amount must be greater than 0 and unit price cannot be negative', isError: true);
      return;
    }

    final totalPrice = amount * unitPrice;

    setState(() {
      _items.add({
        'name': _itemNameController.text.trim(),
        'amount': amount,
        'unitPrice': unitPrice,
        'totalPrice': totalPrice,
        'itemType': _selectedItemType,
      });

      // Reset form fields
      _itemNameController.clear();
      _itemAmountController.text = '1';
      _itemUnitPriceController.text = '0';
      _selectedItemType = 'SUPPLIES';
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _showSnackBar('Item removed', isError: false);
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _createExpense() async {
    if (_expenseNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter an expense name', isError: true);
      return;
    }

    if (_items.isEmpty) {
      _showSnackBar('Please add at least one item', isError: true);
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerId = prefs.getInt('role_id');

      if (ownerId == null) {
        _showSnackBar('Owner ID not found. Please sign in again.', isError: true);
        return;
      }

      final expenseData = {
        'name': _expenseNameController.text.trim(),
        'finalPrice': _totalSum,
        'expenseType': 'PERSONAL',
        'items': _items,
      };

      context.read<ExpenseBloc>().add(
            CreateExpenseForOwnerEvent(
              ownerId: ownerId,
              expenseData: expenseData,
            ),
          );
    } catch (e) {
      _showSnackBar('Error creating expense: $e', isError: true);
    }
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _itemNameController.dispose();
    _itemAmountController.dispose();
    _itemUnitPriceController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Create Expense',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseCreated) {
            _showSnackBar('Expense created successfully!', isError: false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Expenses()),
            );
          } else if (state is ExpenseError) {
            _showSnackBar(state.message, isError: true);
          }
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Header
                  FadeTransition(
                    opacity: _headerAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(_headerAnimation),
                      child: _buildExpenseNameSection(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add Items Section
                  _buildAddItemsSection(state),
                  const SizedBox(height: 24),

                  // Items List
                  _buildItemsList(),
                  const SizedBox(height: 24),

                  // Total Sum
                  _buildTotalSection(),
                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildActionButtons(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpenseNameSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFFFF6B35),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Expense Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _expenseNameController,
            decoration: InputDecoration(
              labelText: 'Expense Name',
              hintText: 'Enter expense name',
              prefixIcon: const Icon(Icons.edit_rounded, color: Color(0xFFFF6B35)),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemsSection(ExpenseState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Color(0xFFFF6B35),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Add Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _itemNameController,
            label: 'Item Name',
            icon: Icons.label_rounded,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _itemAmountController,
                  label: 'Amount',
                  icon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _itemUnitPriceController,
                  label: 'Unit Price',
                  icon: Icons.attach_money_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedItemType,
              decoration: const InputDecoration(
                labelText: 'Item Type',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.category_rounded, color: Color(0xFFFF6B35)),
              ),
              items: _itemTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getItemTypeIcon(type), size: 20, color: const Color(0xFFFF6B35)),
                      const SizedBox(width: 8),
                      Text(type),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedItemType = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state is ExpenseLoading ? null : _addItem,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: const Text(
                'Add Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    if (_items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                'No items added yet',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.list_alt_rounded,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Added Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getItemTypeIcon(item['itemType']),
                    color: const Color(0xFFFF6B35),
                    size: 20,
                  ),
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${item['amount']} × \$${item['unitPrice'].toStringAsFixed(2)} • ${item['itemType']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${item['totalPrice'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                      onPressed: () => _removeItem(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8A5B)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.monetization_on_rounded, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            '\$${_totalSum.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ExpenseState state) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state is ExpenseLoading ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: state is ExpenseLoading ? null : _createExpense,
            icon: state is ExpenseLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check_circle_outline_rounded),
            label: Text(
              state is ExpenseLoading ? 'Saving...' : 'Save Expense',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}

