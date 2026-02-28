
import 'package:hive/hive.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 0) 
class UserEntity {
  @HiveField(0)
  String? codiceFiscale;
  @HiveField(1)
  String? cognome;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? nome;
  @HiveField(4)
  double? saldo;
  @HiveField(5)
  String? phone;
  @HiveField(6)
  String? birthdate;


  UserEntity(
      {this.codiceFiscale, this.cognome, this.email, this.nome, this.saldo, this.phone, this.birthdate});

  @override
  String toString() {
    return 'UserEntity{codiceFiscale: $codiceFiscale, cognome: $cognome, email: $email, nome: $nome, saldo: $saldo, phone: $phone, birthdate: $birthdate}';
  }
}