/// Request model for email registration
class RegisterRequestModel {
  RegisterRequestModel({
    required this.forename,
    required this.surname,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.password,
    this.referralCode,
  });

  final String forename;
  final String surname;
  final String fullName;
  final String email;
  final String countryCode;
  final String phone;
  final String password;
  final String? referralCode;

  Map<String, dynamic> toJson() {
    return {
      'forename': forename,
      'surname': surname,
      'fullName': fullName,
      'email': email,
      'countryCode': countryCode,
      'phone': phone,
      'password': password,
      if (referralCode != null && referralCode!.isNotEmpty)
        'referralCode': referralCode,
    };
  }
}
