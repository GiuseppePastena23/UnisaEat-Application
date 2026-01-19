class AffluenceModel {
  final int? occupancyPercentage;
  final String? level;
  final String? estimatedWait;
  final String? historicalNote;
  final String? status;
  final String? message;

  AffluenceModel({
    this.occupancyPercentage,
    this.level,
    this.estimatedWait,
    this.historicalNote,
    this.status,
    this.message,
  });

  factory AffluenceModel.fromJson(Map<String, dynamic> json) {
    return AffluenceModel(
      occupancyPercentage: json['occupancy_percentage'],
      level: json['level'],
      estimatedWait: json['estimated_wait'],
      historicalNote: json['historical_note'],
      status: json['status'],
      message: json['message'],
    );
  }
}