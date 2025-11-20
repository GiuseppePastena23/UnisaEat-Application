import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', data.data['access_token']);
        return Right(data);
      }
    );
  }
}