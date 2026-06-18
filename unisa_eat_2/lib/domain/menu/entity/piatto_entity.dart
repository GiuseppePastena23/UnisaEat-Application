import 'package:hive/hive.dart';

part 'piatto_entity.g.dart';

@HiveType(typeId: 3)
class PiattoEntity {
  @HiveField(0)
  String? allergeni;
  @HiveField(1)
  String? categoria;
  @HiveField(2)
  double? costoBase;
  @HiveField(3)
  String? descrizione;
  @HiveField(4)
  String? nome;
  @HiveField(5)
  int? piattoId;
  @HiveField(6)
  String? tipo;

  PiattoEntity(
      {this.allergeni,
      this.categoria,
      this.costoBase,
      this.descrizione,
      this.nome,
      this.piattoId,
      this.tipo});
}