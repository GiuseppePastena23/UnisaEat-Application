import 'package:dartz/dartz.dart';

import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/data/auth/sources/auth_api_service.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {

  @override
  Future<Either> login(LogInParams params) async {
    final result = await sl<AuthApiService>().login(params);
    return await result.fold(
      (error) {
        return Left(error); 
      }, (data) async {
        sl<AuthService>().setAccessToken(data.data['access_token']);
        sl<AuthService>().setRefreshToken(data.data['refresh_token']);
        return Right(data);
      }
    );
  }
  
  @override
  Future<Either> refresh(String refreshToken) async {
    final result = await sl<AuthApiService>().refresh(refreshToken);
    return await result.fold(
      (error) {
        return Left(error);
      }, (data) async {
        sl<AuthService>().setAccessToken(data.data['access_token']);
        sl<AuthService>().setRefreshToken(data.data['refresh_token']);
        return Right(data);
      }
    );
  }

  @override
  Future<void> logout() async{
    return sl<AuthService>().logout();
  }
}