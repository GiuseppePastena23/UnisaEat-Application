import 'package:unisa_eat_2/data/order/models/order_model.dart';
import 'package:unisa_eat_2/domain/order/entities/order_entity.dart';
import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';

class OrderMapper {
  static List<OrderEntity> toEntities(List<OrderModel> models) {
    return models.map((model) => OrderEntity(
      id: model.id,
      status: model.status,
      totalCost: model.totalCost,
      note: model.note,
      pickupTime: model.pickupTime,
      createdAt: model.createdAt,
      dishes: model.dishes.map((dish) => OrderDishEntity(
        id: dish.id,
        dish: PiattoEntity(
          piattoId: dish.dishId,
          nome: dish.dishName,
          descrizione: dish.dishDescription,
          costoBase: dish.dishPrice,
          categoria: dish.dishCategory,
          allergeni: dish.dishAllergens,
        ),
        quantity: dish.quantity,
        unitPrice: dish.unitPrice,
        subtotal: dish.subtotal,
      )).toList(),
    )).toList();
  }
}