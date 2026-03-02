
enum TransactionType {
  topup,
  kiosk,
  order,
}

class DishEntity {
  final int? id;
  final String? name;
  final int? quantity;
  final double? price;
  final double? subtotal;

  DishEntity({
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.subtotal,
  });

  factory DishEntity.fromJson(Map<String, dynamic> json) {
    // Backend returns nested 'dish' object with name
    final dishData = json['dish'] is Map ? json['dish'] as Map<String, dynamic> : null;
    return DishEntity(
      id: json['id'],
      name: dishData?['name'] ?? json['name'],
      quantity: json['quantity'],
      price: json['unit_price'] != null ? (json['unit_price'] is num ? (json['unit_price'] as num).toDouble() : double.tryParse(json['unit_price'].toString())) : null,
      subtotal: json['subtotal'] != null ? (json['subtotal'] is num ? (json['subtotal'] as num).toDouble() : double.tryParse(json['subtotal'].toString())) : null,
    );
  }
}

class TransactionEntity {
  final double? amount;
  final String? createdAt;
  final int? id;
  final String? paymentMethod;
  final TransactionType? type;
  final int? userId;
  final List<DishEntity>? dishes;

  TransactionEntity({
    this.amount,
    this.createdAt,
    this.id,
    this.paymentMethod,
    this.type,
    this.userId,
    this.dishes,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    List<DishEntity>? dishesList;
    if (json['dishes'] != null) {
      dishesList = (json['dishes'] as List).map((d) => DishEntity.fromJson(d)).toList();
    }
    
    TransactionType? typeEnum;
    final typeStr = json['type'] as String?;
    if (typeStr != null) {
      typeEnum = TransactionType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => TransactionType.order,
      );
    }
    
    return TransactionEntity(
      amount: json['amount'] != null ? (json['amount'] is num ? (json['amount'] as num).toDouble() : double.tryParse(json['amount'].toString())) : null,
      createdAt: json['created_at'],
      id: json['id'],
      paymentMethod: json['payment_method'],
      type: typeEnum,
      userId: json['user'],
      dishes: dishesList,
    );
  }
  
  String get dateFormatted {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt!);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    } catch (e) {
      return createdAt ?? '';
    }
  }

  bool get isNegative {
    return type == TransactionType.kiosk || type == TransactionType.order;
  }

  String get typeDisplayName {
    if (type == null) return '';
    final name = type!.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  String get dishesSummary {
    if (dishes == null || dishes!.isEmpty) return '';
    if (dishes!.length == 1) {
      return dishes![0].name ?? '';
    }
    return '${dishes!.length} items';
  }
  
  @override
  String toString() {
    return 'TransactionEntity{amount: $amount, createdAt: $createdAt, id: $id, paymentMethod: $paymentMethod, type: $type, userId: $userId, dishes: $dishes}';
  }
}
