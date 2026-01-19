



import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart';

class TransactionModel {
  double? amount;
  String? createdAt;
  int? id;
  String? paymentMethod;
  TransactionType? type;
  int? userId;

  TransactionModel(
      {this.amount,
      this.createdAt,
      this.id,
      this.paymentMethod,
      this.type,
      this.userId});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    // Parse amount from String (Django DecimalField) to double
    if (json['amount'] is String) {
      amount = double.parse(json['amount']);
    } else if (json['amount'] is num) {
      amount = (json['amount'] as num).toDouble();
    } else {
      amount = null;
    }

    createdAt = json['created_at'];

    // Parse id from potentially String to int
    if (json['id'] is String) {
      id = int.parse(json['id']);
    } else if (json['id'] is int) {
      id = json['id'];
    } else {
      id = null;
    }

    paymentMethod = json['payment_method'];
    if (json['type'] != null && json['type'] is String) {
      try {
        type = TransactionType.values.byName(json['type']);
      } catch (e) {
        // If invalid type, default to null
        type = null;
      }
    }

    // Parse userId from potentially String to int
    if (json['user_id'] is String) {
      userId = int.parse(json['user_id']);
    } else if (json['user_id'] is int) {
      userId = json['user_id'];
    } else {
      userId = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['payment_method'] = paymentMethod;
    data['type'] = type.toString();
    data['user_id'] = userId;
    return data;
  }
}