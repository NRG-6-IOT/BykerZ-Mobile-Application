class VehicleCreateRequest {
  final String plate;
  final String year;
  final int modelId;

  VehicleCreateRequest({
    required this.plate,
    required this.year,
    required this.modelId
  });

  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'year': year,
      'modelId': modelId
    };
  }
}