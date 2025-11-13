abstract class MaintenanceEvent {}

class FetchMaintenanceByIdEvent extends MaintenanceEvent {
  final int maintenanceId;

  FetchMaintenanceByIdEvent(this.maintenanceId);
}

class FetchMaintenancesByMechanicIdEvent extends MaintenanceEvent {
  final int mechanicId;

  FetchMaintenancesByMechanicIdEvent(this.mechanicId);
}

class FetchMaintenancesByVehicleIdEvent extends MaintenanceEvent {
  final int vehicleId;

  FetchMaintenancesByVehicleIdEvent(this.vehicleId);
}

class FetchMaintenancesByOwnerIdEvent extends MaintenanceEvent {
  final int ownerId;

  FetchMaintenancesByOwnerIdEvent(this.ownerId);
}

class CreateMaintenanceEvent extends MaintenanceEvent {
  final Map<String, dynamic> maintenanceData;

  CreateMaintenanceEvent({required this.maintenanceData});
}

class DeleteMaintenanceEvent extends MaintenanceEvent {
  final int maintenanceId;

  DeleteMaintenanceEvent(this.maintenanceId);
}

class UpdateMaintenanceStatusEvent extends MaintenanceEvent {
  final int maintenanceId;
  final String newStatus;

  UpdateMaintenanceStatusEvent({
    required this.maintenanceId,
    required this.newStatus,
  });
}

class AssignExpenseToMaintenanceEvent extends MaintenanceEvent {
  final int maintenanceId;
  final int expenseId;

  AssignExpenseToMaintenanceEvent({
    required this.maintenanceId,
    required this.expenseId,
  });
}

