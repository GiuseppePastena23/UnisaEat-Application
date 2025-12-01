
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/wallet/usecases/get_balance_usecase.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_state.dart';
import 'package:unisa_eat_2/service_locator.dart';

class WalletCubit extends Cubit<WalletState>{

  WalletCubit() : super(WalletInitial());

  void getBalance() async {
    emit(WalletLoading());
    var result = await sl<GetBalanceUsecase>().call();
    result.fold(
      (error) => emit(WalletFailure(error.toString())),
      (balance) => emit(WalletSuccess([], balance)),
    );
  }

    
}