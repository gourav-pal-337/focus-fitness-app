/// Response model for email registration
class RegisterResponseModel {
  RegisterResponseModel({
    required this.success,
    required this.message,
    this.user,
    this.tokens,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.emailVerification,
    this.trainerLink,
  });

  final bool success;
  final String message;
  final UserModel? user;
  final TokensModel? tokens;
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final EmailVerificationModel? emailVerification;
  final TrainerLinkModel? trainerLink;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      tokens: json['tokens'] != null
          ? TokensModel.fromJson(json['tokens'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      emailVerification: json['emailVerification'] != null
          ? EmailVerificationModel.fromJson(
              json['emailVerification'] as Map<String, dynamic>,
            )
          : null,
      trainerLink: json['trainerLink'] != null
          ? TrainerLinkModel.fromJson(
              json['trainerLink'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// User model
class UserModel {
  UserModel({
    required this.id,
    required this.role,
    this.fullName,
    this.profilePhoto,
    this.email,
    this.phone,
    this.linkedTrainerId,
    this.dob,
    this.gender,
    this.isTrainerLinked,
    required this.emailVerified,
    required this.phoneVerified,
    required this.status,
    required this.onboardingStage,
    this.termsAcceptedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? dob;
  final String? gender;
  final String role;
  final String? fullName;
  final String? profilePhoto;
  final String? email;
  final String? phone;
  final String? linkedTrainerId;
  final bool? isTrainerLinked;
  final bool emailVerified;
  final bool phoneVerified;
  final String status;
  final String onboardingStage;
  final String? termsAcceptedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      fullName: json['fullName'] as String?,
      gender: json['gender'] as String?,
      // dob: json['dob'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      linkedTrainerId: json['linkedTrainerId'] as String?,
      isTrainerLinked: json['isLinked'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      onboardingStage: json['onboardingStage'] as String? ?? '',
      termsAcceptedAt: json['termsAcceptedAt'] as String?,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      dob: json['dob'] as String? ?? json['dateOfBirth'] as String?,

      updatedAt: DateTime.parse(
        json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'fullName': fullName,
      'profilePhoto': profilePhoto,
      'email': email,
      'phone': phone,
      'linkedTrainerId': linkedTrainerId,
      'isLinked': isTrainerLinked,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'status': status,
      'onboardingStage': onboardingStage,
      'termsAcceptedAt': termsAcceptedAt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Tokens model
class TokensModel {
  TokensModel({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }
}

/// Email verification model
class EmailVerificationModel {
  EmailVerificationModel({required this.status, this.expiresAt, this.error});

  final String status;
  final String? expiresAt;
  final String? error;

  factory EmailVerificationModel.fromJson(Map<String, dynamic> json) {
    return EmailVerificationModel(
      status: json['status'] as String? ?? '',
      expiresAt: json['expiresAt'] as String?,
      error: json['error'] as String?,
    );
  }
}

/// Trainer link model
class TrainerLinkModel {
  TrainerLinkModel({required this.status, this.profile, this.error});

  final String status;
  final TrainerProfileModel? profile;
  final String? error;

  factory TrainerLinkModel.fromJson(Map<String, dynamic> json) {
    return TrainerLinkModel(
      status: json['status'] as String? ?? '',
      profile: json['profile'] != null
          ? TrainerProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>,
            )
          : null,
      error: json['error'] as String?,
    );
  }
}

/// Trainer profile model
class TrainerProfileModel {
  TrainerProfileModel({
    required this.id,
    required this.trainerId,
    required this.fullName,
    required this.email,
    required this.relationshipStatus,
  });

  final String id;
  final String trainerId;
  final String fullName;
  final String email;
  final String relationshipStatus;

  factory TrainerProfileModel.fromJson(Map<String, dynamic> json) {
    return TrainerProfileModel(
      id: json['id'] as String? ?? '',
      trainerId: json['trainerId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      relationshipStatus: json['relationshipStatus'] as String? ?? '',
    );
  }
}
