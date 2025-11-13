class ExpenseItem {
  final int id;
  final String name;
  final double amount;
  final double unitPrice;
  final double totalPrice;
  final String itemType;

  ExpenseItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.unitPrice,
    required this.totalPrice,
    required this.itemType,
  });

  // Factory constructor for creating an instance from JSON
  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      itemType: json['itemType'] as String,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'itemType': itemType,
    };
  }

  // CopyWith method for creating a copy with modified fields
  ExpenseItem copyWith({
    int? id,
    String? name,
    double? amount,
    double? unitPrice,
    double? totalPrice,
    String? itemType,
  }) {
    return ExpenseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      itemType: itemType ?? this.itemType,
    );
  }

  @override
  String toString() {
    return 'ExpenseItem(id: $id, name: $name, amount: $amount, unitPrice: $unitPrice, totalPrice: $totalPrice, itemType: $itemType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseItem &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.unitPrice == unitPrice &&
        other.totalPrice == totalPrice &&
        other.itemType == itemType;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, amount, unitPrice, totalPrice, itemType);
  }
}

