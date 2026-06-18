import 'package:hive/hive.dart';
import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';

part 'menu_entity.g.dart';

@HiveType(typeId: 2)
class MenuEntity {
  @HiveField(0)
  String? dataValidita;
  @HiveField(1)
  String? nome;
  @HiveField(2)
  List<PiattoEntity>? piatti;

  MenuEntity({this.dataValidita, this.nome, this.piatti});
}


