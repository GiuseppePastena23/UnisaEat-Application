class DishSelection {
  final int dishId;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? allergens;
  int quantity;

  DishSelection({
    required this.dishId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.allergens,
    this.quantity = 0,
  });

  double get subtotal => price * quantity;

  DishSelection copyWith({int? quantity}) {
    return DishSelection(
      dishId: dishId,
      name: name,
      description: description,
      price: price,
      category: category,
      allergens: allergens,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish_id': dishId,
      'quantity': quantity,
    };
  }
}

class OrderCreationRequest {
  final List<DishSelection> dishes;
  final String? note;
  final DateTime? pickupTime;
  final bool debugMode;

  OrderCreationRequest({
    required this.dishes,
    this.note,
    this.pickupTime,
    this.debugMode = false,
  });

  double get totalCost => dishes.fold(0.0, (sum, dish) => sum + dish.subtotal);

  Map<String, dynamic> toJson() {
    return {
      'dishes': dishes.map((dish) => dish.toJson()).toList(),
      'note': note,
      'pickup_time': pickupTime?.toIso8601String(),
      'debug_mode': debugMode,
    };
  }

  bool get isValid => dishes.isNotEmpty && dishes.any((dish) => dish.quantity > 0);
}