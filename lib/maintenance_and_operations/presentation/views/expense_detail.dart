import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/expense/expense_bloc.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/expense/expense_event.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/expense/expense_state.dart';
import 'package:byker_z_mobile/maintenance_and_operations/services/expense_service.dart';
import 'package:byker_z_mobile/maintenance_and_operations/model/expense.dart';

class ExpenseDetail extends StatelessWidget {
  final int expenseId;

  const ExpenseDetail({
    super.key,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseBloc(expenseService: ExpenseService())
        ..add(FetchExpenseByIdEvent(expenseId)),
      child: const ExpenseDetailView(),
    );
  }
}

class ExpenseDetailView extends StatelessWidget {
  const ExpenseDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B35),
              ),
            );
          }

          if (state is ExpenseError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ExpenseLoaded) {
            return ExpenseDetailContent(expense: state.expense);
          }

          return const Center(
            child: Text(
              'Loading expense details...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}

class ExpenseDetailContent extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailContent({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expense.expenseType,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table and Final Price Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Items Table
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2.5),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildTableHeaderCell('Name'),
                                _buildTableHeaderCell('Item Type'),
                                _buildTableHeaderCell('Amount'),
                                _buildTableHeaderCell('Unit Price'),
                                _buildTableHeaderCell('Total Price'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Table Body
                      if (expense.items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No items found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2.5),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(2),
                          },
                          children: expense.items.map((item) {
                            return TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              children: [
                                _buildTableCell(item.name),
                                _buildTableCell(item.itemType),
                                _buildTableCell(item.amount.toString()),
                                _buildTableCell(
                                    '\$${item.unitPrice.toStringAsFixed(2)}'),
                                _buildTableCell(
                                    '\$${item.totalPrice.toStringAsFixed(2)}'),
                              ],
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Final Price
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Final Price: \$${expense.finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}

