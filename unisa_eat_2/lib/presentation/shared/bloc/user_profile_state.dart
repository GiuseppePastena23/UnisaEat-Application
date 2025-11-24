import 'package:unisa_eat_2/domain/user/entities/user_entity.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final UserEntity user;

  UserProfileSuccess(this.user);
}

class UserProfileFailure extends UserProfileState {
  final String error;

  UserProfileFailure(this.error);
}