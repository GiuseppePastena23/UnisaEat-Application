import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';

abstract class AuthRepository {
  Future<Either<ApiError, dynamic>> login(LogInParams params);
  Future<Either<ApiError, dynamic>> register(RegisterParams params);
  Future<Either<ApiError, dynamic>> logout();
}