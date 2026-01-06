
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';

abstract class MenuState {
  const MenuState();
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final MenuEntity menu;
  
  const MenuLoaded(this.menu);
}

class MenuError extends MenuState {
  final String message;
  
  const MenuError(this.message);
}
