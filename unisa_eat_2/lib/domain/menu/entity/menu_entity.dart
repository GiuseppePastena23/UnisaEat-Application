
  

class MenuEntity {
  String? createdAt;
  String? dataValidita;
  String? descrizione;
  String? giorniSettimana;
  int? id;
  String? nome;
  List<Piatti>? piatti;

  MenuEntity(
      {this.createdAt,
      this.dataValidita,
      this.descrizione,
      this.giorniSettimana,
      this.id,
      this.nome,
      this.piatti});

  

  
}

class Piatti {
  String? allergeni;
  String? categoria;
  double? costoBase;
  String? createdAt;
  String? descrizione;
  int? id;
  String? nome;
  String? tipo;

  Piatti(
      {this.allergeni,
      this.categoria,
      this.costoBase,
      this.createdAt,
      this.descrizione,
      this.id,
      this.nome,
      this.tipo});
}