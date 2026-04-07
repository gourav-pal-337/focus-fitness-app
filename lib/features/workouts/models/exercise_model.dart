class ExerciseModel {
  const ExerciseModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.level,
    required this.intensity,
    required this.averageMinutes,
    required this.calories,
    required this.description,
    required this.goodFor,
    this.videoUrl,
    this.videoThumbnailUrl,
    this.videoDurationMinutes,
    this.category,
    this.categoryDescription,
    this.instructions,
    this.tips,
    this.commonMistakes,
    this.planSets,
    this.planReps,
    this.restTime,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String level;
  final String intensity;
  final int averageMinutes;
  final int calories;
  final String description;
  final List<String> goodFor;
  final String? videoUrl;
  final String? videoThumbnailUrl;
  final int? videoDurationMinutes;
  final String? category;
  final String? categoryDescription;
  final String? instructions;
  final String? tips;
  final String? commonMistakes;
  final int? planSets;
  final String? planReps;
  final int? restTime;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    final goodForRaw = json['goodFor'];
    final goodFor = goodForRaw is List
        ? goodForRaw.map((e) => e.toString()).toList()
        : <String>[];

    final categoryRaw = json['category'] ?? json['categoryId'];
    String? category;
    if (categoryRaw is String) {
      category = categoryRaw;
    } else if (categoryRaw is Map<String, dynamic>) {
      category = categoryRaw['name']?.toString() ?? categoryRaw['_id']?.toString();
    } else if (categoryRaw != null) {
      category = categoryRaw.toString();
    }

    return ExerciseModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ??
              json['image'] ??
              json['thumbnailUrl'] ??
              '')
          .toString(),
      level: (json['level'] ?? 'Intermediate').toString(),
      intensity: (json['intensity'] ?? 'Moderate').toString(),
      averageMinutes: (json['averageMinutes'] as num? ?? json['durationMinutes'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num? ?? json['caloriesBurn'] as num?)?.toInt() ?? 0,
      description: (json['description'] ?? '').toString(),
      goodFor: goodFor,
      videoUrl: json['videoUrl']?.toString(),
      videoThumbnailUrl: json['videoThumbnailUrl']?.toString(),
      videoDurationMinutes: (json['videoDurationMinutes'] as num?)?.toInt(),
      category: category,
      categoryDescription: json['categoryMeta']?['description']?.toString(),
      instructions: json['instructions']?.toString(),
      tips: json['tips']?.toString(),
      commonMistakes: json['commonMistakes']?.toString(),
      planSets: (json['planSets'] as num?)?.toInt(),
      planReps: json['planReps']?.toString(),
      restTime: (json['restTime'] as num?)?.toInt(),
    );
  }
}
