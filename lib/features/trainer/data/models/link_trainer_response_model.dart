/// Response model for linking trainer
class LinkTrainerResponseModel {
  LinkTrainerResponseModel({
    required this.success,
    required this.message,
    required this.profile,
  });

  final bool success;
  final String message;
  final ClientProfile profile;

  factory LinkTrainerResponseModel.fromJson(Map<String, dynamic> json) {
    return LinkTrainerResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      profile: json['profile'] != null
          ? ClientProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : throw Exception('Profile data is required'),
    );
  }
}

/// Client profile model
class ClientProfile {
  ClientProfile({
    required this.id,
    required this.trainerId,
    required this.fullName,
    required this.referralCode,
    required this.referralLinkedAt,
    required this.relationshipStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.clientUserId,
    this.preferredName,
    this.email,
    this.phone,
    this.goals,
    this.healthNotes,
    this.notes,
    this.tags,
    this.relationshipHistory,
  });

  final String id;
  final String trainerId;
  final String? clientUserId;
  final String fullName;
  final String? preferredName;
  final String? email;
  final String? phone;
  final String referralCode;
  final String referralLinkedAt;
  final String relationshipStatus;
  final String status;
  final String? goals;
  final String? healthNotes;
  final String? notes;
  final List<String>? tags;
  final List<Map<String, dynamic>>? relationshipHistory;
  final String createdAt;
  final String updatedAt;

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    return ClientProfile(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      trainerId: json['trainerId'] as String? ?? '',
      clientUserId: json['clientUserId'] as String?,
      fullName: json['fullName'] as String? ?? '',
      preferredName: json['preferredName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      referralCode: json['referralCode'] as String? ?? '',
      referralLinkedAt: json['referralLinkedAt'] as String? ?? '',
      relationshipStatus: json['relationshipStatus'] as String? ?? '',
      status: json['status'] as String? ?? '',
      goals: json['goals'] as String?,
      healthNotes: json['healthNotes'] as String?,
      notes: json['notes'] as String?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      relationshipHistory: json['relationshipHistory'] != null
          ? List<Map<String, dynamic>>.from(
              json['relationshipHistory'] as List,
            )
          : null,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

