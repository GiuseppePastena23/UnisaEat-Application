import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/domain/menu/usecases/get_menu_by_date_usecase.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_state.dart';
import 'package:unisa_eat_2/service_locator.dart';


class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(const MenuInitial());

  final _getWeeklyMenuUsecase = sl<GetMenuByDateUsecase>();

  /// Fetch menu for a specific date
  /// Date format: 'yyyy-MM-dd'
  Future<void> fetchMenuByDate(String date) async {
    emit(const MenuLoading());
    
    final result = await _getWeeklyMenuUsecase(params: date);
    
    result.fold(
      (error) {
        emit(MenuError(error.toString()));
      },
      (menu) {
        emit(MenuLoaded(menu as MenuEntity));
      },
    );
  }
}
