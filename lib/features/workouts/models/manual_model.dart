class ManualModel {
  const ManualModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.type,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String type;
  final DateTime? createdAt;

  factory ManualModel.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    final createdAtRaw = json['createdAt'];
    if (createdAtRaw is String && createdAtRaw.isNotEmpty) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return ManualModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      fileUrl: (json['fileUrl'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      createdAt: createdAt,
    );
  }
}
