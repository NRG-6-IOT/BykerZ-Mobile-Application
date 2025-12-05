
import '../../domain/entities/wellness_metric.dart';
import '../../domain/repository/wellness_metric_repository.dart';
import '../datasource/wellness_metric_datasource.dart';
import '../models/wellness_metric_model.dart';

class WellnessMetricRepositoryImpl implements WellnessMetricRepository {
  final WellnessMetricDataSource dataSource;

  WellnessMetricRepositoryImpl({required this.dataSource});

  @override
  Future<WellnessMetric> createWellnessMetric(WellnessMetric metric) async {
    final model = WellnessMetricModel.fromEntity(metric);
    final createdModel = await dataSource.createWellnessMetric(model);
    return createdModel.toEntity();
  }

  @override
  Future<WellnessMetric> updateWellnessMetric(int id, WellnessMetric metric) async {
    final model = WellnessMetricModel.fromEntity(metric);
    final updatedModel = await dataSource.updateWellnessMetric(id, model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteWellnessMetric(int id) async {
    await dataSource.deleteWellnessMetric(id);
  }

  @override
  Future<WellnessMetric> getWellnessMetricById(int id) async {
    final model = await dataSource.getWellnessMetricById(id);
    return model.toEntity();
  }

  @override
  Future<List<WellnessMetric>> getAllWellnessMetrics() async {
    final models = await dataSource.getAllWellnessMetrics();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<WellnessMetric>> getWellnessMetricsByVehicleId(int vehicleId) async {
    final models = await dataSource.getWellnessMetricsByVehicleId(vehicleId);
    return models.map((model) => model.toEntity()).toList();
  }
}