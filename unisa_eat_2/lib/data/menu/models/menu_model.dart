import 'package:unisa_eat_2/data/menu/models/piatto_model.dart';

class MenuModel {
  String? dataValidita;
  String? nome;
  List<PiattoModel>? piatti;

  MenuModel({this.dataValidita, this.nome, this.piatti});

  MenuModel.fromJson(Map<String, dynamic> json) {
    dataValidita = null; // Not provided in current response
    nome = json['name'];
    if (json['dishes'] != null) {
      piatti = <PiattoModel>[];
      json['dishes'].forEach((v) {
        piatti!.add(PiattoModel.fromJson(v));
      });
    }
  }

  // Helper function to safely parse numbers (used by PiattoModel)
  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data_validita'] = dataValidita;
    data['nome'] = nome;
    if (piatti != null) {
      data['piatti'] = piatti!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}