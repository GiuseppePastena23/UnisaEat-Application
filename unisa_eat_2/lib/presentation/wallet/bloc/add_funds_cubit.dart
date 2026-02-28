import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/wallet/sources/wallet_api_service.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class AddFundsState {}

class AddFundsInitial extends AddFundsState {}

class AddFundsLoading extends AddFundsState {}

class AddFundsSuccess extends AddFundsState {
  final String clientSecret;

  AddFundsSuccess(this.clientSecret);
}

class AddFundsFailure extends AddFundsState {
  final ApiError error;

  AddFundsFailure(this.error);
}

class AddFundsCubit extends Cubit<AddFundsState> {
  AddFundsCubit() : super(AddFundsInitial());

  Future<void> createPaymentIntent(double amount) async {
    emit(AddFundsLoading());

    final result = await sl<WalletApiService>().createPaymentIntent(amount);

    result.fold(
      (error) => emit(AddFundsFailure(error)),
      (data) {
        final clientSecret = data['client_secret'] as String?;
        if (clientSecret != null) {
          emit(AddFundsSuccess(clientSecret));
        } else {
          emit(AddFundsFailure(ApiError(type: ErrorType.unknown)));
        }
      },
    );
  }
}