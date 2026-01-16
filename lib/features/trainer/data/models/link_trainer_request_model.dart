/// Request model for linking trainer
class LinkTrainerRequestModel {
  LinkTrainerRequestModel({
    required this.referralCode,
    required this.fullName,
    this.preferredName,
    this.email,
    this.phone,
    this.goals,
    this.healthNotes,
    this.notes,
  });

  final String referralCode;
  final String fullName;
  final String? preferredName;
  final String? email;
  final String? phone;
  final String? goals;
  final String? healthNotes;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'referralCode': referralCode.trim().toUpperCase(),
      'fullName': fullName.trim(),
      if (preferredName != null && preferredName!.trim().isNotEmpty)
        'preferredName': preferredName!.trim(),
      if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      if (goals != null && goals!.trim().isNotEmpty) 'goals': goals!.trim(),
      if (healthNotes != null && healthNotes!.trim().isNotEmpty)
        'healthNotes': healthNotes!.trim(),
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}

