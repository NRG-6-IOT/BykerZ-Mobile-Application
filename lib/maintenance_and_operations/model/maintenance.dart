import 'expense.dart';

enum MaintenanceState {
  pending,
  inProgress,
  completed,
  cancelled;

  String toJson() {
    switch (this) {
      case MaintenanceState.pending:
        return 'PENDING';
      case MaintenanceState.inProgress:
        return 'IN_PROGRESS';
      case MaintenanceState.completed:
        return 'COMPLETED';
      case MaintenanceState.cancelled:
        return 'CANCELLED';
    }
  }

  static MaintenanceState fromJson(String value) {
    switch (value) {
      case 'PENDING':
        return MaintenanceState.pending;
      case 'IN_PROGRESS':
        return MaintenanceState.inProgress;
      case 'COMPLETED':
        return MaintenanceState.completed;
      case 'CANCELLED':
        return MaintenanceState.cancelled;
      default:
        throw ArgumentError('Invalid maintenance state: $value');
    }
  }
}

class Maintenance {
  final int id;
  final String details;
  final int vehicleId;
  final String dateOfService;
  final String location;
  final String description;
  final MaintenanceState state;
  final Expense? expense;
  final int mechanicId;

  Maintenance({
    required this.id,
    required this.details,
    required this.vehicleId,
    required this.dateOfService,
    required this.location,
    required this.description,
    required this.state,
    this.expense,
    required this.mechanicId,
  });

  // Factory constructor for creating an instance from JSON
  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'] as int,
      details: json['details'] as String,
      vehicleId: json['vehicleId'] as int,
      dateOfService: json['dateOfService'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      state: MaintenanceState.fromJson(json['state'] as String),
      expense: json['expense'] != null
          ? Expense.fromJson(json['expense'] as Map<String, dynamic>)
          : null,
      mechanicId: json['mechanicId'] as int,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'details': details,
      'vehicleId': vehicleId,
      'dateOfService': dateOfService,
      'location': location,
      'description': description,
      'state': state.toJson(),
      'expense': expense?.toJson(),
      'mechanicId': mechanicId,
    };
  }

  // CopyWith method for creating a copy with modified fields
  Maintenance copyWith({
    int? id,
    String? details,
    int? vehicleId,
    String? dateOfService,
    String? location,
    String? description,
    MaintenanceState? state,
    Expense? expense,
    int? mechanicId,
  }) {
    return Maintenance(
      id: id ?? this.id,
      details: details ?? this.details,
      vehicleId: vehicleId ?? this.vehicleId,
      dateOfService: dateOfService ?? this.dateOfService,
      location: location ?? this.location,
      description: description ?? this.description,
      state: state ?? this.state,
      expense: expense ?? this.expense,
      mechanicId: mechanicId ?? this.mechanicId,
    );
  }

  @override
  String toString() {
    return 'Maintenance(id: $id, details: $details, vehicleId: $vehicleId, dateOfService: $dateOfService, location: $location, description: $description, state: $state, expense: $expense, mechanicId: $mechanicId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Maintenance &&
        other.id == id &&
        other.details == details &&
        other.vehicleId == vehicleId &&
        other.dateOfService == dateOfService &&
        other.location == location &&
        other.description == description &&
        other.state == state &&
        other.expense == expense &&
        other.mechanicId == mechanicId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      details,
      vehicleId,
      dateOfService,
      location,
      description,
      state,
      expense,
      mechanicId,
    );
  }
}

