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
    this.forename,
    this.surname,
    this.preferredName,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.fitnessLevel,
    this.email,
    this.phone,
    this.countryCode,
    this.goals,
    this.weightGoal,
    this.bodyType,
    this.performanceGoal,
    this.healthNotes,
    this.notes,
    this.tags,
    this.profilePicture,
    this.timezone,
  });

  final String id;
  final String? trainerId;
  final String clientUserId;
  final String fullName;
  final String? forename;
  final String? surname;
  final String? preferredName;
  final String? dateOfBirth; // ISO 8601 date string (YYYY-MM-DD)
  final int? age; // Calculated from dateOfBirth
  final String? gender;
  final double? height;
  final double? weight;
  final String? fitnessLevel;
  final String? email;
  final String? phone;
  final String? countryCode;
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
  final String? profilePicture;
  final String? timezone;

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientProfileModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      trainerId: json['trainerId'] as String?,
      clientUserId: json['clientUserId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      forename: json['forename'] as String?,
      surname: json['surname'] as String?,
      preferredName: json['preferredName'] as String?,
      dateOfBirth: json['dob'] as String? ?? json['dateOfBirth'] as String?,
      age: int.parse(json['age'] as String? ?? '0'),
      gender: json['gender'] as String?,
      height: json['height'] != null
          ? (json['height'] as num).toDouble()
          : null,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      fitnessLevel: json['fitnessLevel'] as String?,

      email: json['email'] as String?,
      phone: ((json['phone'] as String?)?.replaceAll(
        json['phoneCountry'] as String? ?? json['countryCode'] as String? ?? '',
        '',
      )),
      countryCode:
          json['phoneCountry'] as String? ?? json['countryCode'] as String?,
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
      profilePicture: json['profilePicture'] as String? ?? json['profilePhoto'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  ClientProfileModel copyWith({
    String? id,
    String? trainerId,
    String? clientUserId,
    String? fullName,
    String? forename,
    String? surname,
    String? preferredName,
    String? dateOfBirth,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? fitnessLevel,
    String? email,
    String? phone,
    String? countryCode,
    String? status,
    String? goals,
    String? weightGoal,
    String? bodyType,
    String? performanceGoal,
    String? healthNotes,
    String? notes,
    List<String>? tags,
    String? createdAt,
    String? updatedAt,
    String? profilePicture,
    String? timezone,
  }) {
    return ClientProfileModel(
      id: id ?? this.id,
      trainerId: trainerId ?? this.trainerId,
      clientUserId: clientUserId ?? this.clientUserId,
      fullName: fullName ?? this.fullName,
      forename: forename ?? this.forename,
      surname: surname ?? this.surname,
      preferredName: preferredName ?? this.preferredName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      status: status ?? this.status,
      goals: goals ?? this.goals,
      weightGoal: weightGoal ?? this.weightGoal,
      bodyType: bodyType ?? this.bodyType,
      performanceGoal: performanceGoal ?? this.performanceGoal,
      healthNotes: healthNotes ?? this.healthNotes,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profilePicture: profilePicture ?? this.profilePicture,
      timezone: timezone ?? this.timezone,
    );
  }
}
