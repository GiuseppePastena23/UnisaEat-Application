import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/home/repositories/home_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetOrderQrcodeUsecase extends Usecase<Either, int> {
  @override
  Future<Either> call({int params = 0}) async {
    return await sl<HomeRepository>().getOrderQrcode(params);
  }
}
