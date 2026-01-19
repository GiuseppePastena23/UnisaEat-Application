part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class RegisterSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final ApiError error;

  LoginFailure(this.error);
}