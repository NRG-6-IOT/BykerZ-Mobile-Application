import 'package:bloc/bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_state.dart';
import 'package:byker_z_mobile/vehicle_management/services/vehicle_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleService vehicleService;

  VehicleBloc({required this.vehicleService}) : super(VehicleInitial()) {
    on<FetchAllVehiclesFromOwnerIdEvent>(_onFetchAllVehiclesFromOwnerIdEvent);
    on<FetchVehicleByIdEvent>(_onFetchVehicleByIdEvent);
    on<CreateVehicleForOwnerIdEvent>(_onCreateVehicleForOwnerIdEvent);
  }

  _onFetchAllVehiclesFromOwnerIdEvent(
      FetchAllVehiclesFromOwnerIdEvent event,
      Emitter<VehicleState> emit
      ) async {
    emit(VehicleLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? roleId = prefs.getInt('role_id');
      if (roleId != null) {
        final vehicles = await vehicleService.getVehiclesByOwnerId(roleId);
        emit(VehiclesLoaded(vehicles: vehicles));
      } else {
        throw Exception("Role Id not found");
      }
    } catch (e) {
      emit(VehicleError(message: "Failed to fetch vehicles: $e"));
    }
  }

  _onFetchVehicleByIdEvent(
      FetchVehicleByIdEvent event,
      Emitter<VehicleState> emit
      ) async {
    emit(VehicleLoading());
    try {
      final vehicle = await vehicleService.getVehicleById(event.vehicleId);
      emit(VehicleLoaded(vehicle: vehicle));
    } catch (e) {
      emit(VehicleError(message: "Failed to fetch vehicle with id ${event.vehicleId}: $e"));
    }
  }

  _onCreateVehicleForOwnerIdEvent(
      CreateVehicleForOwnerIdEvent event,
      Emitter<VehicleState> emit
      ) async {
    emit(VehicleLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? roleId = prefs.getInt('role_id');
      if (roleId != null) {
        final vehicle = await vehicleService.createVehicleForOwnerId(
            roleId,
            event.request
        );
        emit(VehicleCreated(vehicle: vehicle));
        final vehicles = await vehicleService.getVehiclesByOwnerId(roleId);
        emit(VehiclesLoaded(vehicles: vehicles));
      } else {
        throw Exception("Role Id not found");
      }
    } catch (e) {
      emit(VehicleError(message: "Failed to create vehicle: $e"));
    }
  }

}