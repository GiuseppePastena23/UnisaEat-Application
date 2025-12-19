// domain/wallet/entities/transaction_entity.dart
class TransactionEntity {
  final double? amount;
  final String? createdAt;
  final int? id;
  final String? paymentMethod;
  final String? type;
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
    return type == 'kiosk' || type == 'order';
  }

  
  String get typeFormatted {
    switch (type) {
      case 'topup':
        return 'Ricarica';
      case 'kiosk':
        return 'Kiosk';
      case 'order':
        return 'Ordine';
      default:
        return type ?? '';
    }
  }

  @override
  String toString() {
    return 'TransactionEntity{amount: $amount, createdAt: $createdAt, id: $id, paymentMethod: $paymentMethod, type: $type, userId: $userId}';
  }
}
