import 'package:unisa_eat_2/common/helper/mapper/piatto_mapper.dart';
import 'package:unisa_eat_2/data/menu/models/menu_model.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';



class MenuMapper {

  static MenuEntity toEntity(MenuModel model) {
    return MenuEntity(
          dataValidita: model.dataValidita,
          nome: model.nome,
          piatti: model.piatti?.map((piatto) => PiattoMapper.toEntity(piatto)).toList(),
  
          
        );
  }

  
}