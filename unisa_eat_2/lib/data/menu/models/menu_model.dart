
class MenuModel {
  String? createdAt;
  String? dataValidita;
  String? descrizione;
  String? giorniSettimana;
  int? id;
  String? nome;
  List<Piatti>? piatti;

  MenuModel(
      {this.createdAt,
      this.dataValidita,
      this.descrizione,
      this.giorniSettimana,
      this.id,
      this.nome,
      this.piatti});

  MenuModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    dataValidita = json['data_validita'];
    descrizione = json['descrizione'];
    giorniSettimana = json['giorni_settimana'];
    id = json['id'];
    nome = json['nome'];
    if (json['piatti'] != null) {
      piatti = <Piatti>[];
      json['piatti'].forEach((v) {
        piatti!.add(new Piatti.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['data_validita'] = this.dataValidita;
    data['descrizione'] = this.descrizione;
    data['giorni_settimana'] = this.giorniSettimana;
    data['id'] = this.id;
    data['nome'] = this.nome;
    if (this.piatti != null) {
      data['piatti'] = this.piatti!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

