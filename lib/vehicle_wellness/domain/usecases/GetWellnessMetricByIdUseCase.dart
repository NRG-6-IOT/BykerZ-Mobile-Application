import '../entities/wellness_metric.dart';
import '../repository/wellness_metric_repository.dart';

class GetWellnessMetricByIdUseCase {
  final WellnessMetricRepository repository;

  GetWellnessMetricByIdUseCase(this.repository);

  Future<WellnessMetric> call(int wellnessMetricId) {
    // ✅ VALIDACIÓN ESPECÍFICA: WellnessMetricId (de DeleteWellnessMetricCommand)
    _validateWellnessMetricId(wellnessMetricId);

    // Si pasa la validación, eliminar la métrica
    return repository.getWellnessMetricById(wellnessMetricId);
  }

  // ✅ VALIDACIÓN: WellnessMetricId
  void _validateWellnessMetricId(int wellnessMetricId) {
    if (wellnessMetricId <= 0) {
      throw ArgumentError('Wellness Metric ID cannot be null or less than 1');
    }
  }
}