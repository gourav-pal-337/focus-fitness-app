import 'link_trainer_response_model.dart';
import 'trainer_referral_response_model.dart';

/// Response model for get linked trainer
class LinkedTrainerResponseModel {
  LinkedTrainerResponseModel({
    required this.success,
    required this.linked,
    required this.message,
    this.trainer,
    this.profile,
  });

  final bool success;
  final bool linked;
  final String message;
  final TrainerInfo? trainer;
  final ClientProfile? profile;

  factory LinkedTrainerResponseModel.fromJson(Map<String, dynamic> json) {
    return LinkedTrainerResponseModel(
      success: json['success'] as bool? ?? false,
      linked: json['linked'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      trainer: json['trainer'] != null
          ? TrainerInfo.fromJson(json['trainer'] as Map<String, dynamic>)
          : null,
      profile: json['profile'] != null
          ? ClientProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}

