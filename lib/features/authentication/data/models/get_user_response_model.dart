import 'register_response_model.dart';

/// Response model for get current user
class GetUserResponseModel {
  GetUserResponseModel({
    required this.success,
    required this.user,
  });

  final bool success;
  final UserModel user;

  factory GetUserResponseModel.fromJson(Map<String, dynamic> json) {
    return GetUserResponseModel(
      success: json['success'] as bool? ?? false,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : throw Exception('User data is required'),
    );
  }
}

