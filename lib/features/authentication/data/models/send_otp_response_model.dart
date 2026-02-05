class SendOtpResponseModel {
  final bool success;
  final String message;
  final DateTime expiresAt;

  SendOtpResponseModel({
    required this.success,
    required this.message,
    required this.expiresAt,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SendOtpResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}
