class FeedbackModel {
  final int id;
  final int userId;
  final String category;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as int,
      userId: json['user'] is int ? json['user'] : json['user']['id'] as int,
      category: json['category'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'message': message,
    };
  }
}
