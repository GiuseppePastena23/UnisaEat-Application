
abstract class QrCodeState {
}

class QrCodeInitial extends QrCodeState {}

class QrCodeLoading extends QrCodeState {}

class QrCodeSuccess extends QrCodeState {
  final String token;
  final double remainingTime;

  QrCodeSuccess(this.token, {this.remainingTime = 5.0});

}

class QrCodeFailure extends QrCodeState {
  final String message;

  QrCodeFailure(this.message);


}
