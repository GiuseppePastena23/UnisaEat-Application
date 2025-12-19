import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/menu/repository/menu_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetWeeklyMenuUsecase extends Usecase<Either, void> {
  @override
  Future<Either<dynamic, dynamic>> call({void params}) async {
    return await sl<MenuRepository>().getWeeklyMenu();
  }
  
}