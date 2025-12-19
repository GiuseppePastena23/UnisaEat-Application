import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/domain/menu/repository/menu_repository.dart';

class MenuRepositoryImpl extends MenuRepository {
  @override
  Future<Either<dynamic, dynamic>> getWeeklyMenu() async {
    final result = await sl<MenuApiService>().getWeeklyMenu();
    return await result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final menus = data.data['data'] ?? [];
        



      }
    );
  }
}