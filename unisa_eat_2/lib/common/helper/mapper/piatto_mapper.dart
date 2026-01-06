import 'package:unisa_eat_2/data/menu/models/piatto_model.dart';
import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';

class PiattoMapper {

  static PiattoEntity toEntity(PiattoModel model) {
    return PiattoEntity(
          allergeni: model.allergeni,
          categoria: model.categoria,
          costoBase: model.costoBase,
          descrizione: model.descrizione,
          nome: model.nome,
          piattoId: model.piattoId,
          tipo: model.tipo,
  
          
        );
  }

  
}