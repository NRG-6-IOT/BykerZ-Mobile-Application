class VehicleModel {
  final String brand;
  final String name;

  VehicleModel({
    required this.brand,
    required this.name,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      brand: json['brand'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'name': name,
    };
  }
}

class Vehicle {
  final int id;
  final String plate;
  final VehicleModel model;
  final int ownerId;

  Vehicle({
    required this.id,
    required this.plate,
    required this.model,
    required this.ownerId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      plate: json['plate'] as String,
      model: VehicleModel.fromJson(json['model'] as Map<String, dynamic>),
      ownerId: json['ownerId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'model': model.toJson(),
      'ownerId': ownerId,
    };
  }

  Vehicle copyWith({
    int? id,
    String? plate,
    VehicleModel? model,
    int? ownerId,
  }) {
    return Vehicle(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      model: model ?? this.model,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, plate: $plate, model: ${model.brand} ${model.name}, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vehicle &&
        other.id == id &&
        other.plate == plate &&
        other.model == model &&
        other.ownerId == ownerId;
  }

  @override
  int get hashCode => Object.hash(id, plate, model, ownerId);
}

