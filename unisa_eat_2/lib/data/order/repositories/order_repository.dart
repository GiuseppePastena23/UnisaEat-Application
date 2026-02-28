import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/common/helper/mapper/order_mapper.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/order/models/dish_selection_model.dart';
import 'package:unisa_eat_2/data/order/models/order_model.dart';
import 'package:unisa_eat_2/data/order/sources/order_api_service.dart';
import 'package:unisa_eat_2/domain/order/repositories/order_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class OrderRepositoryImpl extends OrderRepository {
  @override
  Future<Either> getOrders() async {
    final result = await sl<OrderApiService>().getOrders();
    return await result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final orders = (data as List).map((e) => OrderModel.fromJson(e)).toList();
        final entities = OrderMapper.toEntities(orders);
        return Right(entities);
      },
    );
  }

  @override
  Future<Either> createOrder(OrderCreationRequest request) async {
    final result = await sl<OrderApiService>().createOrder(request.toJson());
    return await result.fold(
      (error) => Left(error),
      (data) {
        try {
          final order = OrderModel.fromJson(data);
          final entity = OrderMapper.toEntities([order]).first;
          return Right(entity);
        } catch (e) {
          return Left(ApiError(type: ErrorType.unknown, details: {'message': 'Failed to parse response: $e'}));
        }
      },
    );
  }
}