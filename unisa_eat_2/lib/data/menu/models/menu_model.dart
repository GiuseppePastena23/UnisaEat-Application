import 'package:unisa_eat_2/data/menu/models/piatto_model.dart';

class MenuModel {
  String? dataValidita;
  String? nome;
  List<PiattoModel>? piatti;

  MenuModel({this.dataValidita, this.nome, this.piatti});

  MenuModel.fromJson(Map<String, dynamic> json) {
    dataValidita = json['data_validita'];
    nome = json['nome'];
    if (json['piatti'] != null) {
      piatti = <PiattoModel>[];
      json['piatti'].forEach((v) {
        piatti!.add(new PiattoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_validita'] = this.dataValidita;
    data['nome'] = this.nome;
    if (this.piatti != null) {
      data['piatti'] = this.piatti!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}