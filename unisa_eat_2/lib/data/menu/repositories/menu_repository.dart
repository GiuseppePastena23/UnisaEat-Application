import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:unisa_eat_2/common/helper/mapper/menu_mapper.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/menu/models/menu_model.dart';
import 'package:unisa_eat_2/data/menu/sources/menu_api_service.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/domain/menu/repository/menu_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class MenuRepositoryImpl extends MenuRepository {
  @override
  Future<Either> getMenuByDate(String date) async {
    final result = await sl<MenuApiService>().getMenuByDate(date);
    return await result.fold(
      (error) {
        final cached = _getFromCache(date);
        if (cached != null) return Right(cached);
        return Left(error);
      },
      (data) async {
        if (data is List && data.isNotEmpty) {
          final menu = MenuMapper.toEntity(MenuModel.fromJson(data[0]));
          _saveToCache(date, menu);
          return Right(menu);
        } else {
          return Left(ApiError(type: ErrorType.validation, details: {'message': 'No menu found for this date'}));
        }
      }
    );
  }

  void _saveToCache(String date, MenuEntity menu) {
    final box = sl<Box<MenuEntity>>();
    box.put(date, menu);
  }

  MenuEntity? _getFromCache(String date) {
    final box = sl<Box<MenuEntity>>();
    return box.get(date);
  }
}