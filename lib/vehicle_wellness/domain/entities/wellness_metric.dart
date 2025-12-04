class WellnessMetric {

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

  WellnessMetric({
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
    required this.registeredAt,
  });

  //Reglas de negocio pueden ser añadidas aquí

  //Logica centralizada con todas las reglas de negocio
}