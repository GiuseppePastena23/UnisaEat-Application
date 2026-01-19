

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
    allergeni = json['allergens'];
    categoria = json['category'];

    // Safely parse base_cost which might be a string from Django
    if (json['base_cost'] is num) {
      costoBase = (json['base_cost'] as num).toDouble();
    } else if (json['base_cost'] is String) {
      costoBase = double.tryParse(json['base_cost'] as String);
    } else {
      costoBase = null;
    }

    descrizione = json['description'];
    nome = json['name'];
    piattoId = json['id'];
    tipo = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['allergeni'] = allergeni;
    data['categoria'] = categoria;
    data['costo_base'] = costoBase;
    data['descrizione'] = descrizione;
    data['nome'] = nome;
    data['piatto_id'] = piattoId;
    data['tipo'] = tipo;
    return data;
  }
}
