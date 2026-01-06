import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';


class MenuEntity {
  String? dataValidita;
  String? nome;
  List<PiattoEntity>? piatti;

  MenuEntity({this.dataValidita, this.nome, this.piatti});

  
}


