abstract class AssignmentEvent {}

class FetchAssignmentsByMechanicIdAndStatusEvent extends AssignmentEvent {
  final int mechanicId;
  final String status;

  FetchAssignmentsByMechanicIdAndStatusEvent({
    required this.mechanicId,
    required this.status,
  });
}

