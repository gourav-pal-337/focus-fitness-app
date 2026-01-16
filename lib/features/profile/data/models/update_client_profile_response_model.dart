/// Response model for update client profile
class UpdateClientProfileResponseModel {
  UpdateClientProfileResponseModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory UpdateClientProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateClientProfileResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}
