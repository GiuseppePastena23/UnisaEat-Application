import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/wallet/sources/wallet_api_service.dart';
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
}