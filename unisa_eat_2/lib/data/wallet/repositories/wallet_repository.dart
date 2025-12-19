import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/common/helper/mapper/transaction_mapper.dart';
import 'package:unisa_eat_2/data/wallet/models/transaction_model.dart';
import 'package:unisa_eat_2/data/wallet/sources/wallet_api_service.dart';
import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart';
import 'package:unisa_eat_2/domain/wallet/repositories/wallet_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class WalletRepositoryImpl extends WalletRepository {
  @override
  Future<Either> getBalance() async {
    final result = await sl<WalletApiService>().getBalance();
    return await result.fold(
      (error) {
        return Left(Error);
      }, (data) {
        return Right(data.data['balance']);
      }
    );
  }
  
  @override
  Future<Either<dynamic, dynamic>> getTransactions() async {
    final result = await sl<WalletApiService>().getTransactions();
    return await result.fold(
      (error) {
        return Left(error);
      }, 
      (data) {
        
        final List<dynamic> transactionsList = data.data['transactions'] ?? [];
        
        // Mappa ogni TransactionModel a TransactionEntity
        final List<TransactionEntity> transactions = transactionsList
            .map((json) => TransactionMapper.toEntity(
              TransactionModel.fromJson(json as Map<String, dynamic>)
            ))
            .toList();
        
        return Right(transactions);
      }
    );
  }
}