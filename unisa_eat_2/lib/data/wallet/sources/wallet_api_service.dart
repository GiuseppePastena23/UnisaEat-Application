import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class WalletApiService {
  Future<Either> getBalance();

  Future<Either> getTransactions();
}

class WalletApiServiceImpl extends WalletApiService {
  @override
  Future<Either> getBalance() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getBalance); 
      return Right(response);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return Left(e.response!.data['error'] ?? 'Unknown Dio error');
      } else {
        return Left(e.message ?? 'Unknown Dio error');
      }
    }
  }
  
  @override
  Future<Either<dynamic, dynamic>> getTransactions() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getTransactions); 
      return Right(response);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return Left(e.response!.data['error'] ?? 'Unknown Dio error');
      } else {
        return Left(e.message ?? 'Unknown Dio error');
      }
    }
  }


}