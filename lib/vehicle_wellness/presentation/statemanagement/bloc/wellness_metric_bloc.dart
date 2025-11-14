
import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../domain/entities/wellness_metric.dart';
import '../../../domain/usecases/CreateWellnessMetricUseCase.dart';
import '../../../domain/usecases/DeleteWellnessMetricUseCase.dart';
import '../../../domain/usecases/GetWellnessMetricByIdUseCase.dart';
import '../../../domain/usecases/GetWellnessMetricsByVehicleIdUseCase.dart';
import '../../../domain/usecases/UpdateWellnessMetricUseCase.dart';

part 'wellness_metric_event.dart';    // ✅ "metric" singular
part 'wellness_metric_state.dart';    // ✅ "metric" singular

class WellnessMetricBloc  extends Bloc<WellnessMetricEvent, WellnessMetricState> {

  final CreateWellnessMetricUseCase _createWellnessMetric;
  final UpdateWellnessMetricUseCase _updateWellnessMetric;
  final DeleteWellnessMetricUseCase _deleteWellnessMetric;
  final GetWellnessMetricByIdUseCase _getWellnessMetricById;
  final GetWellnessMetricsByVehicleIdUseCase _getWellnessMetricsByVehicleId;

  WellnessMetricBloc({
    required CreateWellnessMetricUseCase createWellnessMetric,
    required UpdateWellnessMetricUseCase updateWellnessMetric,
    required DeleteWellnessMetricUseCase deleteWellnessMetric,
    required GetWellnessMetricByIdUseCase getWellnessMetricById,
    required GetWellnessMetricsByVehicleIdUseCase getWellnessMetricsByVehicleId
  })  : _createWellnessMetric = createWellnessMetric,
        _updateWellnessMetric = updateWellnessMetric,
        _deleteWellnessMetric = deleteWellnessMetric,
        _getWellnessMetricById = getWellnessMetricById,
        _getWellnessMetricsByVehicleId = getWellnessMetricsByVehicleId,
  // _webSocketService = webSocketService,
        super(const WellnessMetricInitial()) {

    // 📖 EVENTOS DE LECTURA (Queries)
    on<LoadWellnessMetricByIdEvent>(_onLoadWellnessMetricByIdEvent);
    on<LoadWellnessMetricsByVehicleIdEvent>(_onLoadWellnessMetricsByVehicleIdEvent);

    // ✏️ EVENTOS DE ESCRITURA (Commands)
    on<CreateWellnessMetricEvent>(_onCreateWellnessMetricEvent);
    on<UpdateWellnessMetricEvent>(_onUpdateWellnessMetricEvent);
    on<DeleteWellnessMetricEvent>(_onDeleteWellnessMetricEvent);


  }

  // 📖 HANDLERS PARA QUERIES

  Future<void> _onLoadWellnessMetricByIdEvent(
      LoadWellnessMetricByIdEvent event,
      Emitter<WellnessMetricState> emit
      ) async {
    // Emitimos el estado de carga
    emit(const WellnessMetricLoading());

    try {
      final metric = await _getWellnessMetricById(event.wellnessMetricId);

      emit(WellnessMetricLoaded(metric: metric));
    } catch (e) {
      emit(WellnessMetricError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadWellnessMetricsByVehicleIdEvent(
      LoadWellnessMetricsByVehicleIdEvent event,
      Emitter<WellnessMetricState> emit
      ) async {
    // Emitimos el estado de carga
    emit(const WellnessMetricsLoading());

    try {
      final metrics = await _getWellnessMetricsByVehicleId(event.vehicleId);

      // Verificamos si la lista está vacía
      if (metrics.isEmpty) {
        emit(const WellnessMetricsEmpty());
      } else {
        emit(WellnessMetricsLoaded(metrics: metrics));
      }
    } catch (e) {
      emit(WellnessMetricsError(errorMessage: e.toString()));
    }
  }

  // ✏️ HANDLERS PARA COMMANDS

  Future<void> _onCreateWellnessMetricEvent(
      CreateWellnessMetricEvent event,
      Emitter<WellnessMetricState> emit
      ) async {
    // Emitimos el estado de progreso
    emit(const CreateWellnessMetricInProgress());

    try {
      final metric = await _createWellnessMetric(event.metric);

      emit(CreateWellnessMetricSuccess(metric: metric));
    } catch (e) {
      emit(CreateWellnessMetricFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateWellnessMetricEvent(
      UpdateWellnessMetricEvent event,
      Emitter<WellnessMetricState> emit
      ) async {
    // Emitimos el estado de progreso con el ID
    emit(UpdateWellnessMetricInProgress(wellnessMetricId: event.wellnessMetricId));

    try {
      // Actualizar UI inmediatamente (optimistic update) - si tienes lista cargada
      if (state is WellnessMetricsLoaded) {
        final currentState = state as WellnessMetricsLoaded;
        final updatedMetrics = currentState.metrics.map((m) {
          if (m.id == event.wellnessMetricId) {
            return event.metric; // Actualizar localmente
          }
          return m;
        }).toList();

        emit(WellnessMetricsLoaded(metrics: updatedMetrics)); // ✅ Actualización inmediata
      }

      // Llamar al use case en segundo plano
      final updatedMetric = await _updateWellnessMetric(event.wellnessMetricId, event.metric);

      // Emitir éxito con la métrica actualizada del servidor
      emit(UpdateWellnessMetricSuccess(metric: updatedMetric));

    } catch (e) {
      // Si hay error, revertir el cambio (si habíamos hecho optimistic update)
      if (state is WellnessMetricsLoaded) {
        final currentState = state as WellnessMetricsLoaded;
        // Aquí podrías revertir a los datos originales si es necesario
        emit(WellnessMetricsLoaded(metrics: currentState.metrics));
      }

      emit(UpdateWellnessMetricFailure(
        error: e.toString(),
        wellnessMetricId: event.wellnessMetricId,
      ));
    }
  }

  Future<void> _onDeleteWellnessMetricEvent(
      DeleteWellnessMetricEvent event,
      Emitter<WellnessMetricState> emit
      ) async {
    // Emitimos el estado de progreso con el ID
    emit(DeleteWellnessMetricInProgress(wellnessMetricId: event.wellnessMetricId));

    try {
      // Actualizar UI inmediatamente (optimistic update) - si tienes lista cargada
      if (state is WellnessMetricsLoaded) {
        final currentState = state as WellnessMetricsLoaded;
        final updatedMetrics = currentState.metrics
            .where((m) => m.id != event.wellnessMetricId)
            .toList();

        emit(WellnessMetricsLoaded(metrics: updatedMetrics)); // ✅ Actualización inmediata
      }

      // Llamar al use case en segundo plano
      await _deleteWellnessMetric(event.wellnessMetricId);

      emit(DeleteWellnessMetricSuccess(wellnessMetricId: event.wellnessMetricId));

    } catch (e) {
      // Si hay error, revertir el cambio (si habíamos hecho optimistic update)
      if (state is WellnessMetricsLoaded) {
        final currentState = state as WellnessMetricsLoaded;
        emit(WellnessMetricsLoaded(metrics: currentState.metrics));
      }

      emit(DeleteWellnessMetricFailure(
        error: e.toString(),
        wellnessMetricId: event.wellnessMetricId,
      ));
    }
  }



  @override
  Future<void> close() {
    return super.close();
  }
}