import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/data/order/models/dish_selection_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<DishSelection> items;
  final double totalCost;

  CartUpdated(this.items, this.totalCost);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  List<DishSelection> _items = [];

  void addItem(DishSelection dish) {
    final existingIndex = _items.indexWhere((item) => item.dishId == dish.dishId);
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(dish.copyWith(quantity: 1));
    }
    _emitUpdatedState();
  }

  void removeItem(int dishId) {
    final existingIndex = _items.indexWhere((item) => item.dishId == dishId);
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: _items[existingIndex].quantity - 1,
        );
      } else {
        _items.removeAt(existingIndex);
      }
    }
    _emitUpdatedState();
  }

  void clearCart() {
    _items.clear();
    _emitUpdatedState();
  }

  void _emitUpdatedState() {
    final totalCost = _items.fold(0.0, (sum, item) => sum + item.subtotal);
    emit(CartUpdated(List.from(_items), totalCost));
  }

  List<DishSelection> get items => List.from(_items);
  double get totalCost => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  bool get isEmpty => _items.isEmpty;
}