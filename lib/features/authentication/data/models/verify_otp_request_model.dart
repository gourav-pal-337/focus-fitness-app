class VerifyOtpRequestModel {
  final String? phone;
  final String? countryCode;
  final String? email;
  final String code;
  final String purpose;
  final String role;
  final String? name;

  VerifyOtpRequestModel({
    this.phone,
    this.countryCode,
    this.email,
    required this.code,
    required this.purpose,
    required this.role,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      if (phone != null) 'phone': phone,
      if (countryCode != null) 'countryCode': countryCode,
      if (email != null) 'email': email,
      'code': code,
      'purpose': purpose,
      'role': role,
      if (name != null) 'fullName': name,
    };
  }
}
