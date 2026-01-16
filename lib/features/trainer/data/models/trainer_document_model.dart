/// Trainer document/certificate model
class TrainerDocument {
  TrainerDocument({
    required this.id,
    required this.field,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.storageKey,
    required this.storageBucket,
    required this.url,
    required this.uploadedAt,
  });

  final String id;
  final String field;
  final String originalName;
  final String mimeType;
  final int size;
  final String storageKey;
  final String storageBucket;
  final String url;
  final String uploadedAt;

  /// Get the document URL
  String? get documentUrl => url;

  factory TrainerDocument.fromJson(Map<String, dynamic> json) {
    return TrainerDocument(
      id: json['_id'] as String? ?? '',
      field: json['field'] as String? ?? '',
      originalName: json['originalName'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      storageKey: json['storageKey'] as String? ?? '',
      storageBucket: json['storageBucket'] as String? ?? '',
      url: json['url'] as String? ?? '',
      uploadedAt: json['uploadedAt'] as String? ?? '',
    );
  }
}

