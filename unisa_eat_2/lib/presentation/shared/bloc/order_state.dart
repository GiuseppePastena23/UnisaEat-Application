import 'package:unisa_eat_2/domain/order/entities/order_entity.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderEntity> orders;
  OrderSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String error;
  OrderFailure(this.error);
}

class OrderCreating extends OrderState {}

class OrderCreated extends OrderState {
  final OrderEntity order;
  OrderCreated(this.order);
}