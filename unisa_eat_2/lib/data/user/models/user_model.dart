class UserModel {
  String? codiceFiscale;
  String? cognome;
  String? email;
  String? nome;
  double? saldo;

  UserModel(
      {this.codiceFiscale, this.cognome, this.email, this.nome, this.saldo});

  UserModel.fromJson(Map<String, dynamic> json) {
    codiceFiscale = json['codice_fiscale'];
    cognome = json['cognome'];
    email = json['email'];
    nome = json['nome'];
    saldo = json['saldo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codice_fiscale'] = codiceFiscale;
    data['cognome'] = cognome;
    data['email'] = email;
    data['nome'] = nome;
    data['saldo'] = saldo;
    return data;
  }
}