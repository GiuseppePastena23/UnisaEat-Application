

abstract class QrcodeState {
}

class QrcodeInitial extends QrcodeState {}

class QrcodeLoading extends QrcodeState {}

class QrcodeSuccess extends QrcodeState {
  final String token;
  
  QrcodeSuccess(this.token);

}

class QrcodeError extends QrcodeState {
  final String message;

  QrcodeError(this.message);

  
}
