import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/wallet/repositories/wallet_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetTransactionsUsecase extends Usecase<dynamic, void> {
  @override
  Future<dynamic> call({params}) async {
    return await sl<WalletRepository>().getTransactions();  }

  
}