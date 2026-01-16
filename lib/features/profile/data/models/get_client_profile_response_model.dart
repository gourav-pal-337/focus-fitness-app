import 'client_profile_model.dart';

/// Response model for getting client profile
class GetClientProfileResponseModel {
  GetClientProfileResponseModel({
    required this.success,
    required this.message,
    this.profile,
  });

  final bool success;
  final String message;
  final ClientProfileModel? profile;

  factory GetClientProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetClientProfileResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      profile: json['profile'] != null
          ? ClientProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}

