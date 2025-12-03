import 'package:bloc/bloc.dart';
import 'package:byker_z_mobile/maintenance_and_operations/model/maintenance.dart';
import 'package:byker_z_mobile/maintenance_and_operations/services/expense_service.dart';
import 'package:byker_z_mobile/maintenance_and_operations/services/maintenance_service.dart';
import 'package:byker_z_mobile/shared/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:byker_z_mobile/shared/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:byker_z_mobile/vehicle_management/services/vehicle_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final VehicleService vehicleService;
  final MaintenanceService maintenanceService;
  final ExpenseService expenseService;

  DashboardBloc({
    required this.vehicleService,
    required this.maintenanceService,
    required this.expenseService
  }) : super(DashboardInitial()) {
    on<FetchAllDataByOwnerId>(_onFetchDataByOwnerIdEvent);
  }

  _onFetchDataByOwnerIdEvent(
      FetchAllDataByOwnerId event,
      Emitter<DashboardState> emit
  ) async {
    emit(DashboardLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? roleId = prefs.getInt('role_id');
      if (roleId != null) {
        final vehicles = await vehicleService.getVehiclesByOwnerId(roleId);
        final expenses = await expenseService.getAllExpenses();
        final maintenances = List.of([]); //Planeo reemplazar esto con la lógica luego;
        emit(DashboardLoaded(vehicles: vehicles, maintenances: maintenances as List<Maintenance>, expenses: expenses));
      } else {
        throw Exception("OwnerId could not be loaded");
      }
    } catch (e) {
      emit(DashboardError(message: "Error when loading dashboard data: $e"));
    }
  }
}