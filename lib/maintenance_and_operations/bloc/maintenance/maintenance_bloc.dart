import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/maintenance/maintenance_event.dart';
import 'package:byker_z_mobile/maintenance_and_operations/bloc/maintenance/maintenance_state.dart';
import 'package:byker_z_mobile/maintenance_and_operations/services/maintenance_service.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final MaintenanceService maintenanceService;

  MaintenanceBloc({required this.maintenanceService}) : super(MaintenanceInitial()) {
    on<FetchMaintenanceByIdEvent>(_onFetchMaintenanceById);
    on<FetchMaintenancesByMechanicIdEvent>(_onFetchMaintenancesByMechanicId);
    on<FetchMaintenancesByVehicleIdEvent>(_onFetchMaintenancesByVehicleId);
    on<CreateMaintenanceEvent>(_onCreateMaintenance);
    on<DeleteMaintenanceEvent>(_onDeleteMaintenance);
    on<UpdateMaintenanceStatusEvent>(_onUpdateMaintenanceStatus);
    on<AssignExpenseToMaintenanceEvent>(_onAssignExpenseToMaintenance);
  }

  Future<void> _onFetchMaintenanceById(
    FetchMaintenanceByIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.getMaintenanceById(event.maintenanceId);
      emit(MaintenanceLoaded(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenance: $e'));
    }
  }

  Future<void> _onFetchMaintenancesByMechanicId(
    FetchMaintenancesByMechanicIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenances = await maintenanceService.getMaintenancesByMechanicId(event.mechanicId);
      emit(MaintenancesLoaded(maintenances));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenances by mechanic: $e'));
    }
  }

  Future<void> _onFetchMaintenancesByVehicleId(
    FetchMaintenancesByVehicleIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenances = await maintenanceService.getMaintenancesByVehicleId(event.vehicleId);
      emit(MaintenancesLoaded(maintenances));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenances by vehicle: $e'));
    }
  }

  Future<void> _onCreateMaintenance(
    CreateMaintenanceEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.createMaintenance(event.maintenanceData);
      emit(MaintenanceCreated(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to create maintenance: $e'));
    }
  }

  Future<void> _onDeleteMaintenance(
    DeleteMaintenanceEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      await maintenanceService.deleteMaintenance(event.maintenanceId);
      emit(MaintenanceDeleted());
    } catch (e) {
      emit(MaintenanceError('Failed to delete maintenance: $e'));
    }
  }

  Future<void> _onUpdateMaintenanceStatus(
    UpdateMaintenanceStatusEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.updateMaintenanceStatus(
        event.maintenanceId,
        event.newStatus,
      );
      emit(MaintenanceStatusUpdated(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to update maintenance status: $e'));
    }
  }

  Future<void> _onAssignExpenseToMaintenance(
    AssignExpenseToMaintenanceEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.assignExpenseToMaintenance(
        event.maintenanceId,
        event.expenseId,
      );
      emit(MaintenanceExpenseAssigned(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to assign expense to maintenance: $e'));
    }
  }
}

