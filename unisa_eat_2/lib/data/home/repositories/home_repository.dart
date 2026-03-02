import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/home/sources/home_api_service.dart';

import 'package:unisa_eat_2/domain/home/repositories/home_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class HomeRepositoryImpl extends HomeRepository {

  
  
  @override
  Future<Either> getQrcode() async{
    final result = await sl<HomeApiService>().getQrcode();
    return await result.fold(
      (error) {
        return Left(error); 
      }, (data) async {

        return Right(data['token']);
      }
    );
  }

  @override
  Future<Either> getOrderQrcode(int orderId) async{
    final result = await sl<HomeApiService>().getOrderQrcode(orderId);
    return await result.fold(
      (error) {
        return Left(error); 
      }, (data) async {

        return Right(data['token']);
      }
    );
  }

}