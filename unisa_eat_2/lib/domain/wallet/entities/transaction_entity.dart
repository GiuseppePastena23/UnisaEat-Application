
enum TransactionType {
  topup,
  kiosk,
  order,
}

class TransactionEntity {
  final double? amount;
  final String? createdAt;
  final int? id;
  final String? paymentMethod;
  final TransactionType? type;
  final int? userId;

  TransactionEntity({
    this.amount,
    this.createdAt,
    this.id,
    this.paymentMethod,
    this.type,
    this.userId,
  });

  
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

  
  

  @override
  String toString() {
    return 'TransactionEntity{amount: $amount, createdAt: $createdAt, id: $id, paymentMethod: $paymentMethod, type: $type, userId: $userId}';
  }
}
