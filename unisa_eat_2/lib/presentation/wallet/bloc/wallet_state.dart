abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletSuccess extends WalletState {
  final List<dynamic> transactions;
  final dynamic balance;

  WalletSuccess(this.transactions, this.balance);
}

class WalletFailure extends WalletState {
  final String error;

  WalletFailure(this.error);
}