import 'set_model.dart';
import 'workout_category_model.dart';

class WorkoutExerciseModel {
  const WorkoutExerciseModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.date,
    required this.sets,
    this.planSets,
    this.planReps,
    this.category,
    this.imageUrl,
    this.level,
    this.intensity,
    this.averageMinutes,
    this.calories,
    this.description,
    this.goodFor,
    this.videoUrl,
    this.videoThumbnailUrl,
    this.videoDurationMinutes,
  });

  final String exerciseId;
  final String exerciseName;
  final DateTime date;
  final List<SetModel> sets;
  final int? planSets;
  final String? planReps;
  final WorkoutCategoryModel? category;
  final String? imageUrl;
  final String? level;
  final String? intensity;
  final int? averageMinutes;
  final int? calories;
  final String? description;
  final List<String>? goodFor;
  final String? videoUrl;
  final String? videoThumbnailUrl;
  final int? videoDurationMinutes;

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets'];
    final parsedSets = rawSets is List
        ? rawSets
              .whereType<Map<String, dynamic>>()
              .map(SetModel.fromJson)
              .toList()
        : <SetModel>[];

    final categoryJson = json['category'];
    final category = categoryJson is Map<String, dynamic>
        ? WorkoutCategoryModel.fromJson(categoryJson)
        : categoryJson is Map
        ? WorkoutCategoryModel.fromJson(Map<String, dynamic>.from(categoryJson))
        : null;

    final goodForRaw = json['goodFor'];
    final goodFor = goodForRaw is List
        ? goodForRaw.map((e) => e.toString()).toList()
        : null;

    return WorkoutExerciseModel(
      exerciseId: (json['exerciseId'] ?? json['id'] ?? '').toString(),
      exerciseName: (json['exerciseName'] ?? json['name'] ?? '').toString(),
      date:
          DateTime.tryParse((json['date'] ?? '').toString()) ?? DateTime.now(),
      sets: parsedSets,
      planSets: _parseInt(json['planSets'] ?? json['expectedSets'] ?? json['targetSets']),
      planReps: (json['planReps'] ?? json['expectedReps'] ?? json['targetReps'])?.toString(),
      category: category,
      imageUrl: json['imageUrl']?.toString(),
      level: json['level']?.toString(),
      intensity: json['intensity']?.toString(),
      averageMinutes: (json['averageMinutes'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      description: json['description']?.toString(),
      goodFor: goodFor,
      videoUrl: json['videoUrl']?.toString(),
      videoThumbnailUrl: json['videoThumbnailUrl']?.toString(),
      videoDurationMinutes: (json['videoDurationMinutes'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'date': date.toIso8601String(),
      'sets': sets.map((set) => set.toJson()).toList(),
      'planSets': planSets,
      'planReps': planReps,
      'category': category?.toJson(),
      'imageUrl': imageUrl,
      'level': level,
      'intensity': intensity,
      'averageMinutes': averageMinutes,
      'calories': calories,
      'description': description,
      'goodFor': goodFor,
      'videoUrl': videoUrl,
      'videoThumbnailUrl': videoThumbnailUrl,
      'videoDurationMinutes': videoDurationMinutes,
    };
  }

  WorkoutExerciseModel copyWith({
    String? exerciseId,
    String? exerciseName,
    DateTime? date,
    List<SetModel>? sets,
    int? planSets,
    String? planReps,
    WorkoutCategoryModel? category,
    String? imageUrl,
    String? level,
    String? intensity,
    int? averageMinutes,
    int? calories,
    String? description,
    List<String>? goodFor,
    String? videoUrl,
    String? videoThumbnailUrl,
    int? videoDurationMinutes,
  }) {
    return WorkoutExerciseModel(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      date: date ?? this.date,
      sets: sets ?? this.sets,
      planSets: planSets ?? this.planSets,
      planReps: planReps ?? this.planReps,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      intensity: intensity ?? this.intensity,
      averageMinutes: averageMinutes ?? this.averageMinutes,
      calories: calories ?? this.calories,
      description: description ?? this.description,
      goodFor: goodFor ?? this.goodFor,
      videoUrl: videoUrl ?? this.videoUrl,
      videoThumbnailUrl: videoThumbnailUrl ?? this.videoThumbnailUrl,
      videoDurationMinutes: videoDurationMinutes ?? this.videoDurationMinutes,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
