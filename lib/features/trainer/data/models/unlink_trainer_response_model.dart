import 'link_trainer_response_model.dart';

/// Response model for unlinking trainer
class UnlinkTrainerResponseModel {
  UnlinkTrainerResponseModel({
    required this.success,
    required this.unlinked,
    required this.message,
    this.profile,
  });

  final bool success;
  final bool unlinked;
  final String message;
  final ClientProfile? profile;

  factory UnlinkTrainerResponseModel.fromJson(Map<String, dynamic> json) {
    return UnlinkTrainerResponseModel(
      success: json['success'] as bool? ?? false,
      unlinked: json['unlinked'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      profile: json['profile'] != null
          ? ClientProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}
