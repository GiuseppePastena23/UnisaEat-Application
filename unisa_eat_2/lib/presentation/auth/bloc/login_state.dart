abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String userToken;

  LoginSuccess(this.userToken);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}