import 'package:dartz/dartz.dart';

import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';
import 'package:unisa_eat_2/data/auth/sources/auth_api_service.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<ApiError, dynamic>> login(LogInParams params) async {
    return await sl<AuthApiService>().login(params);
  }

  @override
  Future<Either<ApiError, dynamic>> register(RegisterParams params) async {
    return await sl<AuthApiService>().register(params);
  }

  @override
  Future<Either<ApiError, dynamic>> logout() async {
    await sl<AuthService>().logout();
    return const Right(null);
  }
}