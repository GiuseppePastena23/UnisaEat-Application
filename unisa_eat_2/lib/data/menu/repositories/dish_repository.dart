import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/menu/sources/dish_api_service.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class DishRepository {
  Future<Either> getDishes();
}

class DishRepositoryImpl extends DishRepository {
  @override
  Future<Either> getDishes() async {
    final result = await sl<DishApiService>().getDishes();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }
}