abstract class DashboardEvent {}

class FetchAllDataByOwnerId extends DashboardEvent {
  final int ownerId;

  FetchAllDataByOwnerId({
    required this.ownerId
  });
}