import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/domain/menu/usecases/get_menu_by_date_usecase.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_state.dart';
import 'package:unisa_eat_2/service_locator.dart';


class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(const MenuInitial());

  final _getWeeklyMenuUsecase = sl<GetMenuByDateUsecase>();

  /// Fetch menu for a specific date with stale-while-revalidate
  /// Date format: 'yyyy-MM-dd'
  Future<void> fetchMenuByDate(String date) async {
    // Check cache first (fast, no network)
    final cached = _getFromCache(date);
    if (cached != null) {
      emit(MenuLoaded(cached));
    } else {
      emit(const MenuLoading());
    }

    // Background refresh from API
    final result = await _getWeeklyMenuUsecase(params: date);

    result.fold(
      (error) {
        if (cached == null) emit(MenuError(error));
      },
      (menu) {
        emit(MenuLoaded(menu as MenuEntity));
      },
    );
  }

  MenuEntity? _getFromCache(String date) {
    try {
      final box = sl<Box<MenuEntity>>();
      return box.get(date);
    } catch (_) {
      return null;
    }
  }
}
