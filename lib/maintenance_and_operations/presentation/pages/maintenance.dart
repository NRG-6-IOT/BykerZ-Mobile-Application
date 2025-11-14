import 'package:byker_z_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/maintenance/maintenance_bloc.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/maintenance/maintenance_event.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/maintenance/maintenance_state.dart';
import 'package:byker_z_mobile/maintenance_and_operations/services/maintenance_service.dart';
import 'package:byker_z_mobile/vehicle_management/services/vehicle_service.dart';
import 'package:byker_z_mobile/iam/services/user_service.dart';
import 'package:byker_z_mobile/maintenance_and_operations/model/maintenance_card.dart';
import 'package:byker_z_mobile/maintenance_and_operations/model/maintenance.dart' as maintenance_model;
import 'package:byker_z_mobile/maintenance_and_operations/presentation/helpers/navigation_helper.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceBloc(
        maintenanceService: MaintenanceService(),
        vehicleService: VehicleService(),
        userService: UserService(),
      ),
      child: const MaintenanceView(),
    );
  }
}

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  @override
  void initState() {
    super.initState();
    _loadMaintenances();
  }

  Future<void> _loadMaintenances() async {
    final prefs = await SharedPreferences.getInstance();
    final ownerId = prefs.getInt('role_id');

    if (ownerId != null) {
      context.read<MaintenanceBloc>().add(FetchMaintenancesByOwnerIdEvent(ownerId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Owner ID not found. Please sign in again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF6B35);
    return Scaffold(
      appBar: AppBar(
        // modern minimal AppBar: white background, orange accent text/icon, no elevation
        title: const Text('Maintenance'),
        backgroundColor: Colors.white,
        foregroundColor: accent,
        elevation: 0,
        centerTitle: false,
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<MaintenanceBloc, MaintenanceState>(
        builder: (context, state) {
          if (state is MaintenanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MaintenanceError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadMaintenances,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MaintenanceCardsLoaded) {
            return RefreshIndicator(
              onRefresh: () async => _loadMaintenances(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scheduled Maintenances Section
                    const Text(
                      'Scheduled Maintenances',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.scheduledMaintenances.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No scheduled maintenances',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    else
                      // send index to each card for staggered animations
                      ...state.scheduledMaintenances
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => MaintenanceCardWidget(card: e.value, isCompleted: false, index: e.key))
                          .toList(),

                    const SizedBox(height: 28),

                    // Completed Maintenances Section
                    const Text(
                      'Maintenances Done',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.completedMaintenances.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No completed maintenances',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    else
                      ...state.completedMaintenances
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => MaintenanceCardWidget(card: e.value, isCompleted: true, index: e.key))
                          .toList(),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text('Pull to refresh or wait for data to load'),
          );
        },
      ),
    );
  }
}

// Reemplazo de MaintenanceCardWidget por versión stateful con animación
class MaintenanceCardWidget extends StatefulWidget {
  final MaintenanceCard card;
  final bool isCompleted;
  final int index; // usado para escalonar animaciones

  const MaintenanceCardWidget({
    super.key,
    required this.card,
    required this.isCompleted,
    this.index = 0,
  });

  @override
  State<MaintenanceCardWidget> createState() => _MaintenanceCardWidgetState();
}

class _MaintenanceCardWidgetState extends State<MaintenanceCardWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // iniciar la animación con un pequeño delay según el índice para stagger
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _getStatusColor(maintenance_model.MaintenanceState state) {
    switch (state) {
      case maintenance_model.MaintenanceState.pending:
        return Colors.yellow.shade100;
      case maintenance_model.MaintenanceState.inProgress:
        return Colors.blue.shade50;
      case maintenance_model.MaintenanceState.completed:
        return Colors.green.shade50;
      case maintenance_model.MaintenanceState.cancelled:
        return Colors.red.shade50;
    }
  }

  Color _getStatusTextColor(maintenance_model.MaintenanceState state) {
    switch (state) {
      case maintenance_model.MaintenanceState.pending:
        return Colors.yellow.shade800;
      case maintenance_model.MaintenanceState.inProgress:
        return Colors.blue.shade800;
      case maintenance_model.MaintenanceState.completed:
        return Colors.green.shade800;
      case maintenance_model.MaintenanceState.cancelled:
        return Colors.red.shade800;
    }
  }

  String _formatState(maintenance_model.MaintenanceState state) {
    return state.toJson();
  }

  // NEW: obtener el nombre del mecanico de forma segura (intenta varios campos)
  String _mechanicDisplay() {
    final mech = widget.card.mechanic;
    if (mech == null) return 'Loading...';
    try {
      final name = (mech as dynamic).name;
      if (name != null && name.toString().trim().isNotEmpty) return name.toString();
    } catch (_) {}
    try {
      final fullName = (mech as dynamic).fullName;
      if (fullName != null && fullName.toString().trim().isNotEmpty) return fullName.toString();
    } catch (_) {}
    try {
      final username = (mech as dynamic).username;
      if (username != null && username.toString().trim().isNotEmpty) return username.toString();
    } catch (_) {}
    return 'Unknown';
  }

  // NEW: representación legible del vehículo (intenta varios campos y falla de forma segura)
  String _vehicleDisplay() {
    final v = (widget.card as dynamic).vehicle;
    if (v == null) return 'Unknown vehicle';
    try {
      final name = (v as dynamic).name;
      if (name != null && name.toString().trim().isNotEmpty) return name.toString();
    } catch (_) {}
    try {
      final model = (v as dynamic).model;
      final brand = (v as dynamic).brand;
      final plate = (v as dynamic).plate ?? (v as dynamic).licensePlate;
      if (brand != null && model != null) return '${brand.toString()} ${model.toString()}';
      if (model != null) return model.toString();
      if (plate != null) return plate.toString();
    } catch (_) {}
    try {
      return v.toString();
    } catch (_) {}
    return 'Unknown vehicle';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
    const accent = Color(0xFFFF6B35);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                // optional: expand or navigate - keep minimal for now
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header row with small accent bar
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 36,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEE, MMM d').format(DateTime.parse(widget.card.maintenance.dateOfService)),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF222222),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('hh:mm a').format(DateTime.parse(widget.card.maintenance.dateOfService)),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // status chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.card.maintenance.state),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatState(widget.card.maintenance.state),
                            style: TextStyle(
                              color: _getStatusTextColor(widget.card.maintenance.state),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // details compact -> ahora incluye Vehicle y muestra el nombre del mecanico
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Location', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(widget.card.maintenance.location, style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 8),
                              const Text('Vehicle', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(_vehicleDisplay(), style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mechanic', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(_mechanicDisplay(), style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 18, thickness: 0.5),
                    const SizedBox(height: 8),
                    Text(
                      widget.card.maintenance.details,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
                    ),
                    if (widget.isCompleted && widget.card.maintenance.expense != null) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 18, thickness: 0.5),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.card.maintenance.expense!.name} - \$${widget.card.maintenance.expense!.finalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              MaintenanceNavigationHelper.navigateToExpenseDetail(
                                context,
                                expenseId: widget.card.maintenance.expense!.id,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: accent,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: const Text('See Details'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
