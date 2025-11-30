import 'package:unisa_eat_2/data/user/models/user_model.dart';
import 'package:unisa_eat_2/domain/user/entities/cached_user.dart';
import 'package:unisa_eat_2/domain/user/entities/user_entity.dart';

class UserMapper {

  static UserEntity toEntity(UserModel model) {
    return UserEntity(
        codiceFiscale: model.codiceFiscale,
        cognome: model.cognome,
        email: model.email,
        nome: model.nome,
        saldo: model.saldo);
  }

  static CachedUser toCachedEntity(UserModel model) {
    final userEntity = toEntity(model);
    return CachedUser.fromEntity(userEntity);
  }
}