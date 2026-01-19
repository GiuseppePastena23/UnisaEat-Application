import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/home/repositories/home_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetQrcodeUsecase extends Usecase<Either, void> {
  @override
  Future<Either> call({void params}) async {
    return await sl<HomeRepository>().getQrcode();
  }
}