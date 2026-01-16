import 'trainer_document_model.dart';

/// Response model for get trainer by referral code (single trainer)
class TrainerReferralResponseModel {
  TrainerReferralResponseModel({
    required this.success,
    required this.message,
    required this.trainer,
  });

  final bool success;
  final String message;
  final TrainerInfo trainer;

  factory TrainerReferralResponseModel.fromJson(Map<String, dynamic> json) {
    return TrainerReferralResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      trainer: json['trainer'] != null
          ? TrainerInfo.fromJson(json['trainer'] as Map<String, dynamic>)
          : throw Exception('Trainer data is required'),
    );
  }
}

/// Response model for search trainers (multiple trainers)
class TrainerSearchResponseModel {
  TrainerSearchResponseModel({
    required this.success,
    required this.message,
    required this.trainers,
    required this.count,
  });

  final bool success;
  final String message;
  final List<TrainerInfo> trainers;
  final int count;

  factory TrainerSearchResponseModel.fromJson(Map<String, dynamic> json) {
    return TrainerSearchResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      trainers: json['trainers'] != null
          ? (json['trainers'] as List)
              .map((item) => TrainerInfo.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      count: json['count'] as int? ?? 0,
    );
  }
}

/// Trainer information model
class TrainerInfo {
  TrainerInfo({
    required this.id,
    required this.referralCode,
    this.userId,
    this.fullName,
    this.preferredName,
    this.profilePhoto,
    this.bioSummary,
    this.expertiseAreas,
    this.sessionTypes,
    this.trainingPhilosophy,
    this.documents,
  });

  final String id;
  final String referralCode;
  final String? userId;
  final String? fullName;
  final String? preferredName;
  final String? profilePhoto;
  final String? bioSummary;
  final List<String>? expertiseAreas;
  final List<String>? sessionTypes;
  final String? trainingPhilosophy;
  final List<TrainerDocument>? documents;

  factory TrainerInfo.fromJson(Map<String, dynamic> json) {
    return TrainerInfo(
      id: json['id'] as String? ?? '',
      referralCode: json['referralCode'] as String? ?? '',
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      preferredName: json['preferredName'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      bioSummary: json['bioSummary'] as String?,
      expertiseAreas: json['expertiseAreas'] != null
          ? List<String>.from(json['expertiseAreas'] as List)
          : null,
      sessionTypes: json['sessionTypes'] != null
          ? List<String>.from(json['sessionTypes'] as List)
          : null,
      trainingPhilosophy: json['trainingPhilosophy'] as String?,
      documents: json['documents'] != null
          ? (json['documents'] as List)
              .map((item) => TrainerDocument.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Get display name (preferred name or full name)
  String get displayName => preferredName ?? fullName ?? 'Trainer';
}

