import 'package:byker_z_mobile/vehicle_management/model/vehicle_model.dart';

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleError extends VehicleState {
  final String message;

  VehicleError({
    required this.message
  });
}

class VehiclesLoaded extends VehicleState {
  final List<Vehicle> vehicles;

  VehiclesLoaded({
    required this.vehicles
  });
}

class VehicleLoaded extends VehicleState {
  final Vehicle vehicle;

  VehicleLoaded({
    required this.vehicle
  });
}

class VehicleCreated extends VehicleState {
  final Vehicle vehicle;

  VehicleCreated({
    required this.vehicle
  });
}