/// Request model for booking a session
class BookSessionRequestModel {
  BookSessionRequestModel({
    required this.trainerId,
    required this.sessionPlanId,
    required this.startTime,
    required this.endTime,
    this.timezone,
    this.notes,
  });

  final String trainerId;
  final String sessionPlanId;
  final String startTime; // ISO 8601 timestamp
  final String endTime; // ISO 8601 timestamp
  final String? timezone;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
      'sessionPlanId': sessionPlanId,
      'startTime': startTime,
      'endTime': endTime,
      if (timezone != null) 'timezone': timezone,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}


