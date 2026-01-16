/// Standalone client profile model (for profiles without trainer)
class ClientProfileModel {
  ClientProfileModel({
    required this.id,
    required this.clientUserId,
    required this.fullName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.trainerId,
    this.preferredName,
    this.dateOfBirth,
    this.age,
    this.height,
    this.weight,
    this.fitnessLevel,
    this.email,
    this.phone,
    this.goals,
    this.weightGoal,
    this.bodyType,
    this.performanceGoal,
    this.healthNotes,
    this.notes,
    this.tags,
  });

  final String id;
  final String? trainerId;
  final String clientUserId;
  final String fullName;
  final String? preferredName;
  final String? dateOfBirth; // ISO 8601 date string (YYYY-MM-DD)
  final int? age; // Calculated from dateOfBirth
  final double? height;
  final double? weight;
  final String? fitnessLevel;
  final String? email;
  final String? phone;
  final String status;
  final String? goals;
  final String? weightGoal;
  final String? bodyType;
  final String? performanceGoal;
  final String? healthNotes;
  final String? notes;
  final List<String>? tags;
  final String createdAt;
  final String updatedAt;

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientProfileModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      trainerId: json['trainerId'] as String?,
      clientUserId: json['clientUserId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      preferredName: json['preferredName'] as String?,
      dateOfBirth: json['dob'] as String? ?? json['dateOfBirth'] as String?,
      age: json['age'] as int?,
      height: json['height'] != null
          ? (json['height'] as num).toDouble()
          : null,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      fitnessLevel: json['fitnessLevel'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'active',
      goals: json['goals'] as String?,
      weightGoal: json['weightGoal'] as String?,
      bodyType: json['bodyType'] as String?,
      performanceGoal: json['performanceGoal'] as String?,
      healthNotes: json['healthNotes'] as String?,
      notes: json['notes'] as String?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

