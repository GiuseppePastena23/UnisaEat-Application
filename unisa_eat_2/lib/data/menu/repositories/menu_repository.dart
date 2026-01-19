import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/common/helper/mapper/menu_mapper.dart';
import 'package:unisa_eat_2/data/menu/models/menu_model.dart';
import 'package:unisa_eat_2/data/menu/sources/menu_api_service.dart';
import 'package:unisa_eat_2/domain/menu/repository/menu_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class MenuRepositoryImpl extends MenuRepository {
  @override
  Future<Either> getMenuByDate(String date) async {
    final result = await sl<MenuApiService>().getMenuByDate(date);
    return await result.fold(
      (error) => Left(error),
      (data) async {
        // Backend returns a list of menus, take the first one
        if (data is List && data.isNotEmpty) {
          final menu = MenuMapper.toEntity(MenuModel.fromJson(data[0]));
          return Right(menu);
        } else {
          return Left('No menu found for this date');
        }
      }
    );
  }
  
}