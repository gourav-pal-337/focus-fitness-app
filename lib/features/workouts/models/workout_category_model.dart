class WorkoutCategoryModel {
  const WorkoutCategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final String? description;

  factory WorkoutCategoryModel.fromJson(Map<String, dynamic> json) {
    return WorkoutCategoryModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      imageUrl: json['imageUrl']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}

