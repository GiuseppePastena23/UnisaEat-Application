import 'package:unisa_eat_2/data/wallet/models/transaction_model.dart';

import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart' ;

class TransactionMapper {

  static TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
          amount: model.amount,
          createdAt: model.createdAt,
          id: model.id,
          paymentMethod: model.paymentMethod,
          type: model.type,
          userId: model.userId,
          
        );
  }

  
}