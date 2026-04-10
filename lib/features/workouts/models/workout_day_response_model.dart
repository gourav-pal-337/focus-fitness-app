import 'workout_exercise_model.dart';

class WorkoutDayResponseModel {
  final List<WorkoutExerciseModel> progress;
  final bool isRestDay;
  final String? dayTitle;
  final bool success;

  WorkoutDayResponseModel({
    required this.progress,
    required this.isRestDay,
    this.dayTitle,
    required this.success,
  });

  factory WorkoutDayResponseModel.fromJson(Map<String, dynamic> json) {
    var progressList = <WorkoutExerciseModel>[];
    
    // Check multiple potential keys for progress list
    final keys = ['progress', 'workouts', 'data', 'results'];
    for (final key in keys) {
      if (json[key] is List) {
        progressList = (json[key] as List)
            .whereType<Map<String, dynamic>>()
            .map(WorkoutExerciseModel.fromJson)
            .toList();
        break;
      }
      // Handle nested structures like: { data: { workouts: [...] } }
      if (json[key] is Map<String, dynamic>) {
        final nestedMap = json[key] as Map<String, dynamic>;
        for (final innerKey in keys) {
          if (nestedMap[innerKey] is List) {
            progressList = (nestedMap[innerKey] as List)
                .whereType<Map<String, dynamic>>()
                .map(WorkoutExerciseModel.fromJson)
                .toList();
            break;
          }
        }
        if (progressList.isNotEmpty) break;
      }
    }

    return WorkoutDayResponseModel(
      progress: progressList,
      isRestDay: json['isRestDay'] ?? false,
      dayTitle: json['dayTitle'],
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progress': progress.map((e) => e.toJson()).toList(),
      'isRestDay': isRestDay,
      'dayTitle': dayTitle,
      'success': success,
    };
  }
}
