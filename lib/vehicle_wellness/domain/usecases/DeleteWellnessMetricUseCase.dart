// domain/usecases/delete_wellness_metric.dart
import '../repository/wellness_metric_repository.dart';

class DeleteWellnessMetricUseCase {
  final WellnessMetricRepository repository;

  DeleteWellnessMetricUseCase(this.repository);

  Future<void> call(int wellnessMetricId) {
    
    _validateWellnessMetricId(wellnessMetricId);

    
    return repository.deleteWellnessMetric(wellnessMetricId);
  }

  
  void _validateWellnessMetricId(int wellnessMetricId) {
    if (wellnessMetricId <= 0) {
      throw ArgumentError('Wellness Metric ID cannot be null or less than 1');
    }
  }
}
