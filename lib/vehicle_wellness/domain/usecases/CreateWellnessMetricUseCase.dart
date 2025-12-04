// domain/usecases/create_wellness_metric.dart
import '../entities/wellness_metric.dart';
import '../repository/wellness_metric_repository.dart';

class CreateWellnessMetricUseCase {
  final WellnessMetricRepository repository;

  CreateWellnessMetricUseCase(this.repository);

  Future<WellnessMetric> call(WellnessMetric metric) {
    // ✅ APLICAR TODAS LAS VALIDACIONES DEL BACKEND
    _validateVehicleId(metric.vehicleId);
    _validateCoordinates(metric.latitude, metric.longitude);
    _validateAirQuality(metric.CO2Ppm, metric.NH3Ppm, metric.BenzenePpm);
    _validateAtmosphericPressure(metric.pressureHpa);
    _validateStatusImpact(metric.impactDetected);

    // Si pasa todas las validaciones, crear la métrica
    return repository.createWellnessMetric(metric);
  }

  // ✅ VALIDACIÓN: VehicleId (de CreateWellnessMetricCommand)
  void _validateVehicleId(int vehicleId) {
    if (vehicleId <= 0) {
      throw ArgumentError('vehicleId cannot be less than or equal to zero');
    }
  }

  // ✅ VALIDACIÓN: Coordinates (de Coordinates value object)
  void _validateCoordinates(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90 degrees');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180 degrees');
    }
  }

  // ✅ VALIDACIÓN: AirQuality (de AirQuality value object)
  void _validateAirQuality(double co2Ppm, double nh3Ppm, double benzenePpm) {
    if (co2Ppm < 0) {
      throw ArgumentError('CO2Ppm cannot be negative');
    }
    if (nh3Ppm < 0) {
      throw ArgumentError('NH3Ppm cannot be negative');
    }
    if (benzenePpm < 0) {
      throw ArgumentError('BenzenePpm cannot be negative');
    }
  }

  // ✅ VALIDACIÓN: EnvironmentalConditions (de EnvironmentalConditions value object)
  void _validateEnvironmentalConditions(double temperatureCelsius, double humidityPercentage) {
    if (temperatureCelsius < -50 || temperatureCelsius > 60) {
      throw ArgumentError('Temperature must be between -50 and 60 Celsius');
    }
    if (humidityPercentage < 0 || humidityPercentage > 100) {
      throw ArgumentError('Humidity percentage must be between 0 and 100');
    }
  }

  // ✅ VALIDACIÓN: AtmosphericPressure (de AtmosphericPressure value object)
  void _validateAtmosphericPressure(double pressureHpa) {
    if (pressureHpa < 300.0 || pressureHpa > 1100.0) {
      throw ArgumentError('Atmospheric pressure must be between 300 and 1100 hPa');
    }
  }

  // ✅ VALIDACIÓN: StatusImpact (de StatusImpact value object)
  void _validateStatusImpact(bool impactDetected) {
    // En Dart, bool no puede ser null si es required, pero validamos por consistencia
    if (impactDetected == null) {
      throw ArgumentError('impactDetected cannot be null');
    }
  }
}