import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';

class OrderDishEntity {
  final int id;
  final PiattoEntity dish;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderDishEntity({
    required this.id,
    required this.dish,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderDishEntity.fromJson(Map<String, dynamic> json) {
    return OrderDishEntity(
      id: json['id'],
      dish: PiattoEntity(
        piattoId: json['dish']['id'],
        nome: json['dish']['name'],
        descrizione: json['dish']['description'],
        costoBase: json['dish']['base_cost'].toDouble(),
        categoria: json['dish']['category'],
        allergeni: json['dish']['allergens'],
      ),
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }
}

class OrderEntity {
  final int id;
  final String status;
  final double totalCost;
  final String? note;
  final DateTime? pickupTime;
  final DateTime createdAt;
  final List<OrderDishEntity> dishes;

  OrderEntity({
    required this.id,
    required this.status,
    required this.totalCost,
    this.note,
    this.pickupTime,
    required this.createdAt,
    required this.dishes,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'],
      status: json['status'],
      totalCost: _parseDouble(json['total_cost']),
      note: json['note'],
      pickupTime: json['pickup_time'] != null ? DateTime.parse(json['pickup_time']) : null,
      createdAt: DateTime.parse(json['created_at']),
      dishes: (json['dishes'] as List<dynamic>?)
          ?.map((dish) => OrderDishEntity.fromJson(dish))
          .toList() ?? [],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}