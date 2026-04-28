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
    required this.isAcceptedTerms,
    this.referralCode,
  });

  final String forename;
  final String surname;
  final String fullName;
  final String email;
  final String countryCode;
  final String phone;
  final String password;
  final bool isAcceptedTerms;
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
      'isAcceptedTerms': isAcceptedTerms,
      if (referralCode != null && referralCode!.isNotEmpty)
        'referralCode': referralCode,
    };
  }
}
