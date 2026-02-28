import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class WalletApiService {
  Future<Either<ApiError, dynamic>> getBalance();

  Future<Either<ApiError, dynamic>> getTransactions();

  Future<Either<ApiError, dynamic>> createPaymentIntent(double amount);
}

class WalletApiServiceImpl extends WalletApiService {
  @override
  Future<Either<ApiError, dynamic>> getBalance() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getBalance);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getTransactions() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getTransactions);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> createPaymentIntent(double amount) async {
    try {
      var response = await sl<DioClient>().post(
        'api/payments/create-payment-intent/',
        data: {'amount': amount.toString()},
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}