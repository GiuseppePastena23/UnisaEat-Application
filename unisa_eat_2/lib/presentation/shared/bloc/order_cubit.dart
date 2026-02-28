import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/data/order/models/dish_selection_model.dart';
import 'package:unisa_eat_2/domain/order/entities/order_entity.dart';
import 'package:unisa_eat_2/domain/order/usecases/create_order_usecase.dart';
import 'package:unisa_eat_2/domain/order/usecases/get_orders_usecase.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/order_state.dart';
import 'package:unisa_eat_2/service_locator.dart';

class OrderCubit extends Cubit<OrderState> {
  Timer? _timer;

  OrderCubit() : super(OrderInitial());

  void getOrders() async {
    emit(OrderLoading());
    _cancelTimer();
    var result = await sl<GetOrdersUsecase>().call();
    result.fold(
      (error) => emit(OrderFailure(error)),
      (orders) {
        emit(OrderSuccess(orders));
        _startTimerIfNeeded(orders);
      },
    );
  }

  void createOrder(OrderCreationRequest request) async {
    emit(OrderCreating());
    var result = await sl<CreateOrderUsecase>().call(params: request);
    result.fold(
      (error) => emit(OrderFailure(error)),
      (order) => emit(OrderCreated(order)),
    );
  }

  void deleteOrder(int orderId) async {
    try {
      await sl<DioClient>().delete('api/orders/$orderId/');
      // On success, refresh orders
      getOrders();
    } catch (e) {
      // For simplicity, emit failure or ignore
      emit(OrderFailure(ApiError(type: ErrorType.unknown)));
    }
  }

  void _startTimerIfNeeded(List<OrderEntity> orders) {
    const activeStatuses = ['pending', 'confirmed', 'preparing', 'ready'];
    final hasActiveOrders = orders.any((o) => activeStatuses.contains(o.status.toLowerCase()));
    if (hasActiveOrders) {
      _timer = Timer.periodic(const Duration(seconds: 30), (_) => getOrders());
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _cancelTimer();
    emit(OrderInitial());
  }
}