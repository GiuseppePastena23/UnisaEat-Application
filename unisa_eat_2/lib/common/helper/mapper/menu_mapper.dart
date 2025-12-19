import 'package:unisa_eat_2/data/menu/models/menu_model.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';

class MenuMapper {

  static MenuEntity toEntity(MenuModel model) {
    return MenuEntity(
      id: model.id,
      name: model.nome,
      piatti: model.piatti!.map((e) => Piatti(
        allergeni: e.allergeni,
        categoria: e.categoria,
        costoBase: e.costoBase,
        createdAt: e.createdAt,
        descrizione: e.descrizione,
        id: e.id,
        nome: e.nome,
        tipo: e.tipo,
      )).toList(),
    );
  }
}