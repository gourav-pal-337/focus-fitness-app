class SendOtpRequestModel {
  final String? phone;
  final String? countryCode;
  final String? email;
  final String purpose;
  final String role;

  SendOtpRequestModel({
    this.phone,
    this.countryCode,
    this.email,
    required this.purpose,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      if (phone != null) 'phone': phone,
      if (countryCode != null) 'countryCode': countryCode,
      if (email != null) 'email': email,
      'purpose': purpose,
      'role': role,
    };
  }
}
