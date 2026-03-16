import 'register_response_model.dart';

/// Response model for email login
class LoginResponseModel {
  LoginResponseModel({
    required this.success,
    required this.message,
    this.user,
    this.tokens,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.emailVerificationRequired = false,
    this.tfaRequired = false,
    this.userId,
    this.maskedPhone,
    this.phoneCountry,
  });

  final bool success;
  final String message;
  final UserModel? user;
  final TokensModel? tokens;
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final bool emailVerificationRequired;
  final bool tfaRequired;
  final String? userId;
  final String? maskedPhone;
  final String? phoneCountry;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
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
      emailVerificationRequired:
          json['emailVerificationRequired'] as bool? ?? false,
      tfaRequired: json['tfaRequired'] as bool? ?? false,
      userId: json['userId'] as String?,
      maskedPhone: json['maskedPhone'] as String?,
      phoneCountry: json['phoneCountry'] as String?,
    );
  }
}
