import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';

abstract class AuthRepository {

  Future<Either> login(LogInParams loginParams);

  Future<Either> refresh(String refreshToken);

  Future<void> logout();
}