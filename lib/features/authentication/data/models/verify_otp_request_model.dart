class VerifyOtpRequestModel {
  final String phone;
  final String code;
  final String purpose;
  final String role;

  VerifyOtpRequestModel({
    required this.phone,
    required this.code,
    required this.purpose,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'code': code, 'purpose': purpose, 'role': role};
  }
}
