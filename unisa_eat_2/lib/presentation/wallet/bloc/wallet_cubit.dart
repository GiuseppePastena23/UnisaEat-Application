
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/wallet/entities/transaction_entity.dart';
import 'package:unisa_eat_2/domain/wallet/usecases/get_balance_usecase.dart';
import 'package:unisa_eat_2/domain/wallet/usecases/get_transactions_usecase.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_state.dart';
import 'package:unisa_eat_2/service_locator.dart';

class WalletCubit extends Cubit<WalletState>{

  WalletCubit() : super(WalletInitial());

  void getData() async {
    emit(WalletLoading());
    
    try {
      
      final balanceResult = await sl<GetBalanceUsecase>().call();
      final transactionsResult = await sl<GetTransactionsUsecase>().call();

      balanceResult.fold(
        (error) => emit(WalletFailure(error.toString())),
        (balance) {
          transactionsResult.fold(
            (error) => emit(WalletFailure(error.toString())),
            (transactions) {
              
              emit(WalletSuccess(
                transactions as List<TransactionEntity>,
                balance as double
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(WalletFailure('Unexpected error: $e'));
    }
  }

    
}