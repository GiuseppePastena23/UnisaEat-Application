import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/data/order/models/dish_selection_model.dart';
import 'package:unisa_eat_2/domain/order/repositories/order_repository.dart';

class CreateOrderUsecase extends Usecase<Either, OrderCreationRequest> {
  final OrderRepository orderRepository;

  CreateOrderUsecase(this.orderRepository);

  @override
  Future<Either> call({OrderCreationRequest? params}) async {
    if (params == null) throw ArgumentError('params cannot be null');
    return await orderRepository.createOrder(params);
  }
}