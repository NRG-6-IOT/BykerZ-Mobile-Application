import 'expense_item.dart';

class Expense {
  final int id;
  final String name;
  final double finalPrice;
  final String expenseType;
  final List<ExpenseItem> items;

  Expense({
    required this.id,
    required this.name,
    required this.finalPrice,
    required this.expenseType,
    required this.items,
  });

  // Factory constructor for creating an instance from JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      name: json['name'] as String,
      finalPrice: (json['finalPrice'] as num).toDouble(),
      expenseType: json['expenseType'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => ExpenseItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'finalPrice': finalPrice,
      'expenseType': expenseType,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // CopyWith method for creating a copy with modified fields
  Expense copyWith({
    int? id,
    String? name,
    double? finalPrice,
    String? expenseType,
    List<ExpenseItem>? items,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      finalPrice: finalPrice ?? this.finalPrice,
      expenseType: expenseType ?? this.expenseType,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, name: $name, finalPrice: $finalPrice, expenseType: $expenseType, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense &&
        other.id == id &&
        other.name == name &&
        other.finalPrice == finalPrice &&
        other.expenseType == expenseType &&
        _listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return Object.hash(id, name, finalPrice, expenseType, Object.hashAll(items));
  }

  // Helper method for list equality comparison
  bool _listEquals(List<ExpenseItem> a, List<ExpenseItem> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

