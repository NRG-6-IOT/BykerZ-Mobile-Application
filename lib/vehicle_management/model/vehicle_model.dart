class Model {
  final int id;
  final String name;
  final String brand;
  final String modelYear;
  final String originCountry;
  final String producedAt;
  final String type;
  final String displacement;
  final String potency;
  final String engineType;
  final String engineTorque;
  final String weight;
  final String transmission;
  final String brakes;
  final String tank;
  final String seatHeight;
  final String consumption;
  final String price;
  final String oilCapacity;
  final String connectivity;
  final String durability;
  final String octane;

  Model({
    required this.id,
    required this.name,
    required this.brand,
    required this.modelYear,
    required this.originCountry,
    required this.producedAt,
    required this.type,
    required this.displacement,
    required this.potency,
    required this.engineType,
    required this.engineTorque,
    required this.weight,
    required this.transmission,
    required this.brakes,
    required this.tank,
    required this.seatHeight,
    required this.consumption,
    required this.price,
    required this.oilCapacity,
    required this.connectivity,
    required this.durability,
    required this.octane,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String,
      modelYear: json['modelYear'] as String,
      originCountry: json['originCountry'] as String,
      producedAt: json['producedAt'] as String,
      type: json['type'] as String,
      displacement: json['displacement'] as String,
      potency: json['potency'] as String,
      engineType: json['engineType'] as String,
      engineTorque: json['engineTorque'] as String,
      weight: json['weight'] as String,
      transmission: json['transmission'] as String,
      brakes: json['brakes'] as String,
      tank: json['tank'] as String,
      seatHeight: json['seatHeight'] as String,
      consumption: json['consumption'] as String,
      price: json['price'] as String,
      oilCapacity: json['oilCapacity'] as String,
      connectivity: json['connectivity'] as String,
      durability: json['durability'] as String,
      octane: json['octane'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'modelYear': modelYear,
      'originCountry': originCountry,
      'producedAt': producedAt,
      'type': type,
      'displacement': displacement,
      'potency': potency,
      'engineType': engineType,
      'engineTorque': engineTorque,
      'weight': weight,
      'transmission': transmission,
      'brakes': brakes,
      'tank': tank,
      'seatHeight': seatHeight,
      'consumption': consumption,
      'price': price,
      'oilCapacity': oilCapacity,
      'connectivity': connectivity,
      'durability': durability,
      'octane': octane,
    };
  }
}

class Vehicle {
  final int id;
  final int ownerId;
  final Model model;
  final String year;
  final String plate;

  Vehicle({
    required this.id,
    required this.ownerId,
    required this.model,
    required this.year,
    required this.plate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      ownerId: json['ownerId'] as int,
      model: Model.fromJson(json['model'] as Map<String, dynamic>),
      year: json['year'] as String,
      plate: json['plate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'model': model.toJson(),
      'year': year,
      'plate': plate,
    };
  }

  Vehicle copyWith({
    int? id,
    int? ownerId,
    Model? model,
    String? year,
    String? plate,
  }) {
    return Vehicle(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
    );
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, ownerId: $ownerId, plate: $plate, year: $year, model: ${model?.brand ?? "N/A"} ${model?.name ?? ""})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vehicle &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.model == model &&
        other.year == year &&
        other.plate == plate;
  }

  @override
  int get hashCode => Object.hash(id, ownerId, model, year, plate);
}
