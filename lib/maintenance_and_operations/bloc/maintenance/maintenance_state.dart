import 'package:byker_z_mobile/maintenance_and_operations/model/maintenance.dart';

abstract class MaintenanceState {}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceLoaded extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceLoaded(this.maintenance);
}

class MaintenancesLoaded extends MaintenanceState {
  final List<Maintenance> maintenances;

  MaintenancesLoaded(this.maintenances);
}

class MaintenanceCreated extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceCreated(this.maintenance);
}

class MaintenanceDeleted extends MaintenanceState {}

class MaintenanceStatusUpdated extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceStatusUpdated(this.maintenance);
}

class MaintenanceExpenseAssigned extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceExpenseAssigned(this.maintenance);
}

class MaintenanceError extends MaintenanceState {
  final String message;

  MaintenanceError(this.message);
}

