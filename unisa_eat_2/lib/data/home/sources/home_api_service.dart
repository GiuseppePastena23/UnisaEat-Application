import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class HomeApiService {
  Future<Either<ApiError, dynamic>> getQrcode();
  Future<Either<ApiError, dynamic>> getOrderQrcode(int orderId);
}

class HomeApiServiceImpl extends HomeApiService {
  @override
  Future<Either<ApiError, dynamic>> getQrcode() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getQrcode);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getOrderQrcode(int orderId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getQrcode}?type=order&order_id=$orderId',
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}
