class SendOtpRequestModel {
  final String phone;
  final String purpose;
  final String role;

  SendOtpRequestModel({
    required this.phone,
    required this.purpose,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'purpose': purpose, 'role': role};
  }
}
