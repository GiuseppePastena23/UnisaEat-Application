import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class AuthApiService {
  Future<Either> login(LogInParams params);

}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> login(LogInParams params) async {
    
    try {
      var response = await sl<DioClient>().post(ApiUrl.login, data: params.toJson());
      return Right(response);
    } on DioException catch(e) {
      if (e.response?.data is Map<String, dynamic>) {
          return Left(e.response!.data['error'] ?? 'Unknown Dio error');
        } else {
          return Left(e.message ?? 'Unknown Dio error');
        }
    } 
  }
}