import '../../domain/entities/wellness_metric.dart';

class WellnessMetricModel {

  final int id;
  final int vehicleId;
  final double latitude;
  final double longitude;
  final double CO2Ppm;
  final double NH3Ppm;
  final double BenzenePpm;
  final double temperatureCelsius;
  final double pressureHpa;
  final bool impactDetected;
  final DateTime? registeredAt;

  WellnessMetricModel({
    required this.id,
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.CO2Ppm,
    required this.NH3Ppm,
    required this.BenzenePpm,
    required this.temperatureCelsius,
    required this.pressureHpa,
    required this.impactDetected,
    this.registeredAt,
  });

  factory WellnessMetricModel.fromJson(Map<String,dynamic> json){
    return WellnessMetricModel(
      id: json["id"] as int,
      vehicleId: json["vehicleId"] as int,
      latitude: json["latitude"] as double,
      longitude: json["longitude"] as double,
      CO2Ppm: json["CO2Ppm"] as double,
      NH3Ppm: json["NH3Ppm"] as double,
      BenzenePpm: json["BenzenePpm"] as double,
      temperatureCelsius: json["temperatureCelsius"] as double,
      pressureHpa: json["pressureHpa"] as double,
      impactDetected: json["impactDetected"] as bool,
      registeredAt: _parseDateTime(json["registeredAt"]),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('❌ Error parsing DateTime: $value');
        return null;
      }
    }
    return null;
  }

  WellnessMetric toEntity() {
    return WellnessMetric(
      id: id,
      vehicleId: vehicleId,
      latitude: latitude,
      longitude: longitude,
      CO2Ppm: CO2Ppm,
      NH3Ppm: NH3Ppm,
      BenzenePpm: BenzenePpm,
      temperatureCelsius: temperatureCelsius,
      pressureHpa: pressureHpa,
      impactDetected: impactDetected,
      registeredAt: registeredAt,
    );
  }

  bool getImpactDetected() {
    return impactDetected;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'latitude': latitude,
      'longitude': longitude,
      'CO2Ppm': CO2Ppm,
      'NH3Ppm': NH3Ppm,
      'BenzenePpm': BenzenePpm,
      'temperatureCelsius': temperatureCelsius,
      'pressureHpa': pressureHpa,
      'impactDetected': impactDetected,
      'registeredAt': registeredAt?.toIso8601String(),
    };
  }

  factory WellnessMetricModel.fromEntity(WellnessMetric entity) {
    return WellnessMetricModel(
      id: entity.id,
      vehicleId: entity.vehicleId,
      latitude: entity.latitude,
      longitude: entity.longitude,
      CO2Ppm: entity.CO2Ppm,
      NH3Ppm: entity.NH3Ppm,
      BenzenePpm: entity.BenzenePpm,
      temperatureCelsius: entity.temperatureCelsius,
      pressureHpa: entity.pressureHpa,
      impactDetected: entity.impactDetected,
      registeredAt: entity.registeredAt,
    );
  }
}