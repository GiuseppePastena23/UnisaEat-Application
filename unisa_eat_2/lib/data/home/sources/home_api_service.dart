import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class HomeApiService {
  Future<Either> getQrcode();
}

class HomeApiServiceImpl extends HomeApiService {
 
  
  @override
  Future<Either> getQrcode() async{
    try {
      var response = await sl<DioClient>().get(ApiUrl.getQrcode,);
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
