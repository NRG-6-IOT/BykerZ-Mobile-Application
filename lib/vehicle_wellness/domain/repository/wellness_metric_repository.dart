import '../entities/wellness_metric.dart';

abstract class WellnessMetricRepository {

  Future<WellnessMetric> createWellnessMetric(WellnessMetric metric);
  Future<WellnessMetric> updateWellnessMetric(int id, WellnessMetric metric);
  Future<void> deleteWellnessMetric(int id);
  Future<WellnessMetric> getWellnessMetricById(int id);
  Future<List<WellnessMetric>> getAllWellnessMetrics();
  Future<List<WellnessMetric>> getWellnessMetricsByVehicleId(int vehicleId);


}