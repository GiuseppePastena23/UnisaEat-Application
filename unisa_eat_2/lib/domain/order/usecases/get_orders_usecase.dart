import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/order/repositories/order_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetOrdersUsecase extends Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<OrderRepository>().getOrders();
  }
}