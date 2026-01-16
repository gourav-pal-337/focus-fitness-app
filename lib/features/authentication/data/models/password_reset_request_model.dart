/// Request model for requesting password reset
class PasswordResetRequestModel {
  PasswordResetRequestModel({
    required this.email,
  });

  final String email;

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
    };
  }
}

/// Request model for confirming password reset
class PasswordResetConfirmModel {
  PasswordResetConfirmModel({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  final String email;
  final String code;
  final String newPassword;

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'code': code.trim(),
      'newPassword': newPassword,
    };
  }
}

