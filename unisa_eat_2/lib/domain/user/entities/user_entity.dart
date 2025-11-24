class UserEntity {
  String? codiceFiscale;
  String? cognome;
  String? email;
  String? nome;
  double? saldo;

  UserEntity(
      {this.codiceFiscale, this.cognome, this.email, this.nome, this.saldo});

  String toString() {
    return 'UserModel{codiceFiscale: $codiceFiscale, cognome: $cognome, email: $email, nome: $nome, saldo: $saldo}';
  }
}