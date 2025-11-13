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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scheduled Maintenances Section
                    const Text(
                      'Scheduled Maintenances',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.scheduledMaintenances.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No scheduled maintenances',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    else
                      ...state.scheduledMaintenances.map((card) =>
                        MaintenanceCardWidget(card: card, isCompleted: false)
                      ),

                    const SizedBox(height: 32),

                    // Completed Maintenances Section
                    const Text(
                      'Maintenances Done',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.completedMaintenances.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No completed maintenances',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    else
                      ...state.completedMaintenances.map((card) =>
                        MaintenanceCardWidget(card: card, isCompleted: true)
                      ),
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

class MaintenanceCardWidget extends StatelessWidget {
  final MaintenanceCard card;
  final bool isCompleted;

  const MaintenanceCardWidget({
    super.key,
    required this.card,
    required this.isCompleted,
  });

  Color _getStatusColor(maintenance_model.MaintenanceState state) {
    switch (state) {
      case maintenance_model.MaintenanceState.pending:
        return Colors.yellow.shade200;
      case maintenance_model.MaintenanceState.inProgress:
        return Colors.blue.shade200;
      case maintenance_model.MaintenanceState.completed:
        return Colors.green.shade200;
      case maintenance_model.MaintenanceState.cancelled:
        return Colors.red.shade200;
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date & Time:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(dateFormat.format(DateTime.parse(card.maintenance.dateOfService))),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(card.maintenance.location),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mechanic:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(card.mechanic?.username ?? 'Loading...'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vehicle:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.vehicle != null
                            ? '${card.vehicle!.model.brand} ${card.vehicle!.model.name} - ${card.vehicle!.plate}'
                            : 'Loading...',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(card.maintenance.details),
            const SizedBox(height: 16),
            const Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(card.maintenance.state),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatState(card.maintenance.state),
                style: TextStyle(
                  color: _getStatusTextColor(card.maintenance.state),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            if (isCompleted && card.maintenance.expense != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Expense:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${card.maintenance.expense!.name} - \$${card.maintenance.expense!.finalPrice.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/expense-details',
                      arguments: card.maintenance.expense!.id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'See Expense Details',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
