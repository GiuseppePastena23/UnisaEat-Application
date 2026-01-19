import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/order/models/dish_selection_model.dart';

abstract class OrderRepository {
  Future<Either> getOrders();
  Future<Either> createOrder(OrderCreationRequest request);
}