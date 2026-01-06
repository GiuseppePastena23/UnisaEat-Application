

class PiattoModel {
  String? allergeni;
  String? categoria;
  double? costoBase;
  String? descrizione;
  String? nome;
  int? piattoId;
  String? tipo;

  PiattoModel(
      {this.allergeni,
      this.categoria,
      this.costoBase,
      this.descrizione,
      this.nome,
      this.piattoId,
      this.tipo});

  PiattoModel.fromJson(Map<String, dynamic> json) {
    allergeni = json['allergeni'];
    categoria = json['categoria'];
    costoBase = json['costo_base'];
    descrizione = json['descrizione'];
    nome = json['nome'];
    piattoId = json['piatto_id'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allergeni'] = this.allergeni;
    data['categoria'] = this.categoria;
    data['costo_base'] = this.costoBase;
    data['descrizione'] = this.descrizione;
    data['nome'] = this.nome;
    data['piatto_id'] = this.piattoId;
    data['tipo'] = this.tipo;
    return data;
  }
}
