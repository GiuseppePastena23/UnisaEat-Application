import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart';

class TransactionMapper {

  static TransactionEntity toEntityFromJson(Map<String, dynamic> json) {
    return TransactionEntity.fromJson(json);
  }
  
}
