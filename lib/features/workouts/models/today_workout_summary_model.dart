class TodayWorkoutSummaryModel {
  final bool hasWorkout;
  final String? planName;
  final String? title;
  final int? exerciseCount;
  final int? completedSets;
  final int? totalSets;
  final String? status; // 'not_started' | 'in_progress' | 'completed'
  final int? progress;
  final String? message;
  final String? thumbnail;

  TodayWorkoutSummaryModel({
    required this.hasWorkout,
    this.planName,
    this.title,
    this.exerciseCount,
    this.completedSets,
    this.totalSets,
    this.status,
    this.progress,
    this.message,
    this.thumbnail,
  });

  factory TodayWorkoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return TodayWorkoutSummaryModel(
      hasWorkout: json['hasWorkout'] ?? false,
      planName: json['planName'],
      title: json['title'],
      exerciseCount: json['exerciseCount'],
      completedSets: json['completedSets'],
      totalSets: json['totalSets'],
      status: json['status'],
      progress: json['progress'],
      message: json['message'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasWorkout': hasWorkout,
      'planName': planName,
      'title': title,
      'exerciseCount': exerciseCount,
      'completedSets': completedSets,
      'totalSets': totalSets,
      'status': status,
      'progress': progress,
      'message': message,
      'thumbnail': thumbnail,
    };
  }
}
