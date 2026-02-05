/// Request model for Firebase login (Google/Apple)
class FirebaseLoginRequestModel {
  FirebaseLoginRequestModel({
    required this.idToken,
    this.role = 'client',
    this.email,
    this.fullName,
    required this.provider,
  });

  final String idToken;
  final String role;
  final String? email;
  final String? fullName;
  final String provider; // 'google' or 'apple'

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'role': role,
      'email': email,
      'fullName': fullName,
      'provider': provider,
    };
  }
}
