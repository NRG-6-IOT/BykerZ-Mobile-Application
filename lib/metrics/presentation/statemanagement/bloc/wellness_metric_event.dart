// presentation/bloc/wellness_metric_event.dart
part of 'wellness_metric_bloc.dart';




abstract class WellnessMetricEvent {}

// 📖 EVENTOS DE LECTURA (Queries)

class LoadWellnessMetricByIdEvent extends WellnessMetricEvent  {
  final int wellnessMetricId;
  LoadWellnessMetricByIdEvent(this.wellnessMetricId);
}

class LoadWellnessMetricsByVehicleIdEvent extends WellnessMetricEvent  {
  final int vehicleId;
  LoadWellnessMetricsByVehicleIdEvent(this.vehicleId);
}

// ✏️ EVENTOS DE ESCRITURA (Commands)
class CreateWellnessMetricEvent extends WellnessMetricEvent  {
  final WellnessMetric metric;
  CreateWellnessMetricEvent(this.metric);
}

class UpdateWellnessMetricEvent extends WellnessMetricEvent  {
  final int wellnessMetricId;
  final WellnessMetric metric;
  UpdateWellnessMetricEvent(this.wellnessMetricId, this.metric);
}

class DeleteWellnessMetricEvent extends WellnessMetricEvent  {
  final int wellnessMetricId;
  DeleteWellnessMetricEvent(this.wellnessMetricId);
}

