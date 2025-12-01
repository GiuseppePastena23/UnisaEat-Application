

abstract class QrcodeState {
}

class QrcodeInitial extends QrcodeState {}

class QrcodeLoading extends QrcodeState {}

class QrcodeSuccess extends QrcodeState {
  final String token;
  final double remainingTime;
  
  QrcodeSuccess(this.token, {this.remainingTime = 5.0});

}

class QrcodeError extends QrcodeState {
  final String message;

  QrcodeError(this.message);

  
}
