class OrderDishModel {
  final int id;
  final int dishId;
  final String dishName;
  final String dishDescription;
  final double dishPrice;
  final String dishCategory;
  final String? dishAllergens;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderDishModel({
    required this.id,
    required this.dishId,
    required this.dishName,
    required this.dishDescription,
    required this.dishPrice,
    required this.dishCategory,
    this.dishAllergens,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderDishModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse numbers
    double _parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return OrderDishModel(
      id: json['id'],
      dishId: json['dish']['id'],
      dishName: json['dish']['name'],
      dishDescription: json['dish']['description'] ?? '',
      dishPrice: _parseDouble(json['dish']['base_cost']),
      dishCategory: json['dish']['category'],
      dishAllergens: json['dish']['allergens'],
      quantity: json['quantity'],
      unitPrice: _parseDouble(json['unit_price']),
      subtotal: _parseDouble(json['subtotal']),
    );
  }
}

class OrderModel {
  final int id;
  final String status;
  final double totalCost;
  final String? note;
  final DateTime? pickupTime;
  final DateTime createdAt;
  final List<OrderDishModel> dishes;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalCost,
    this.note,
    this.pickupTime,
    required this.createdAt,
    required this.dishes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse numbers
    double _parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return OrderModel(
      id: json['id'],
      status: json['status'],
      totalCost: _parseDouble(json['total_cost']),
      note: json['note'],
      pickupTime: json['pickup_time'] != null ? DateTime.parse(json['pickup_time']) : null,
      createdAt: DateTime.parse(json['created_at']),
      dishes: (json['dishes'] as List<dynamic>?)
          ?.map((dish) => OrderDishModel.fromJson(dish))
          .toList() ?? [],
    );
  }
}