import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';

class FAQModel {
  final int id;
  final String category;
  final String question;
  final String answer;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  FAQModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] as int,
      category: json['category'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      order: json['order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'answer': answer,
      'order': order,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
