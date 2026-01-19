import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class UserApiService {
  Future<Either<ApiError, dynamic>> getUser();
}

class UserApiServiceImpl extends UserApiService {
  @override
  Future<Either<ApiError, dynamic>> getUser() async {

    try {
      var response = await sl<DioClient>().get(ApiUrl.getUser);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e.response?.data ?? e.message));
    }
  }
}
