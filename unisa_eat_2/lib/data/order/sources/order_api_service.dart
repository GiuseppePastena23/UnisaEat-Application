import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class OrderApiService {
  Future<Either<ApiError, dynamic>> getOrders();
  Future<Either<ApiError, dynamic>> createOrder(Map<String, dynamic> requestData);
}

class OrderApiServiceImpl implements OrderApiService {
  @override
  Future<Either<ApiError, dynamic>> getOrders() async {
    try {
      var response = await sl<DioClient>().get('${ApiUrl.baseURL}api/orders/');
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> createOrder(Map<String, dynamic> requestData) async {
    try {
      var response = await sl<DioClient>().post('${ApiUrl.baseURL}api/orders/create_order/', data: requestData);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}