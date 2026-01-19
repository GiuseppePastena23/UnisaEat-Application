import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/data/menu/repositories/dish_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetDishesUsecase extends Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<DishRepository>().getDishes();
  }
}