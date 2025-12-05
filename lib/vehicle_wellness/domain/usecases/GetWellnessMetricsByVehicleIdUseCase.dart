import '../entities/wellness_metric.dart';
import '../repository/wellness_metric_repository.dart';

class GetWellnessMetricsByVehicleIdUseCase {
  final WellnessMetricRepository repository;

  GetWellnessMetricsByVehicleIdUseCase(this.repository);

  Future<List<WellnessMetric>> call(int vehicleId) {
    
    _validateVehicleId(vehicleId);

    return repository.getWellnessMetricsByVehicleId(vehicleId);
  }

  
  void _validateVehicleId(int vehicleId) {
    if (vehicleId <= 0) {
      throw ArgumentError('vehicleId cannot be null, less than or equal to zero');
    }
  }
}
