/// Request model for email registration
class RegisterRequestModel {
  RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    this.referralCode,
  });

  final String fullName;
  final String email;
  final String password;
  final String? referralCode;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      if (referralCode != null && referralCode!.isNotEmpty)
        'referralCode': referralCode,
    };
  }
}

