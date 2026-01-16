/// Response model for booking a session
class BookSessionResponseModel {
  BookSessionResponseModel({
    required this.success,
    required this.message,
    this.booking,
  });

  final bool success;
  final String message;
  final BookingModel? booking;

  factory BookSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return BookSessionResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      booking: json['booking'] != null
          ? BookingModel.fromJson(json['booking'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Booking model
class BookingModel {
  BookingModel({
    required this.id,
    required this.trainerId,
    this.sessionPlanId,
    this.clientId,
    required this.clientName,
    this.clientEmail,
    this.clientPhone,
    required this.startTime,
    required this.endTime,
    required this.timezone,
    required this.status,
    this.notes,
    this.trainerNotes,
    this.rescheduleHistory,
    this.cancellationReason,
    this.paymentReference,
    this.rating,
    this.feedback,
    this.ratedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String trainerId;
  final String? sessionPlanId;
  final String? clientId;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String startTime;
  final String endTime;
  final String timezone;
  final String status;
  final String? notes;
  final String? trainerNotes;
  final List<dynamic>? rescheduleHistory;
  final String? cancellationReason;
  final String? paymentReference;
  final num? rating;
  final String? feedback;
  final String? ratedAt;
  final String createdAt;
  final String updatedAt;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] as String? ?? '',
      trainerId: json['trainerId'] as String? ?? '',
      sessionPlanId: json['sessionPlanId'] as String?,
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String? ?? '',
      clientEmail: json['clientEmail'] as String?,
      clientPhone: json['clientPhone'] as String?,
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      timezone: json['timezone'] as String? ?? 'UTC',
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      trainerNotes: json['trainerNotes'] as String?,
      rescheduleHistory: json['rescheduleHistory'] as List<dynamic>?,
      cancellationReason: json['cancellationReason'] as String?,
      paymentReference: json['paymentReference'] as String?,
      rating: json['rating'] as num?,
      feedback: json['feedback'] as String?,
      ratedAt: json['ratedAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}


