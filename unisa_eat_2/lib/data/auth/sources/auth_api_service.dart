import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class AuthApiService {
  Future<Either<ApiError, dynamic>> login(LogInParams params);
  Future<Either<ApiError, dynamic>> register(RegisterParams params);
  Future<Either<ApiError, dynamic>> refresh(String refreshToken);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either<ApiError, dynamic>> login(LogInParams params) async {
    try {
      var response = await sl<DioClient>().post(ApiUrl.login, data: {'email': params.email, 'password': params.password});
      return Right(response.data);
    } catch(e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> register(RegisterParams params) async {
    try {
      var response = await sl<DioClient>().post(ApiUrl.register, data: params.toJson());
      return Right(response.data);
    } catch(e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> refresh(String refreshToken) async {
    try {
      var response = await sl<DioClient>().post(ApiUrl.refresh, data: {'refresh': refreshToken});
      return Right(response.data);
    } catch(e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}