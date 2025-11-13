import 'package:byker_z_mobile/vehicle_management/model/vehicle_create_request.dart';

abstract class VehicleEvent {}

class FetchAllVehiclesFromOwnerIdEvent extends VehicleEvent {
  final int ownerId;

  FetchAllVehiclesFromOwnerIdEvent({
    required this.ownerId
  });
}

class CreateVehicleForOwnerIdEvent extends VehicleEvent {
  final int ownerId;
  final VehicleCreateRequest request;

  CreateVehicleForOwnerIdEvent({
    required this.ownerId,
    required this.request
  });
}

class FetchVehicleByIdEvent extends VehicleEvent {
  final int vehicleId;

  FetchVehicleByIdEvent({
    required this.vehicleId
  });
}