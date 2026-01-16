/// Booking model for client bookings
class BookingModel {
  BookingModel({
    required this.id,
    required this.trainerId,
    required this.clientName,
    required this.startTime,
    required this.endTime,
    required this.timezone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.sessionPlanId,
    this.clientId,
    this.clientEmail,
    this.clientPhone,
    this.notes,
    this.trainerNotes,
    this.rescheduleHistory,
    this.cancellationReason,
    this.paymentReference,
    this.rating,
    this.feedback,
    this.ratedAt,
    this.invoiceUrl,
    this.trainer,
    this.sessionPlan,
  });

  final String id;
  final String trainerId;
  final String? sessionPlanId;
  final String? clientId;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String startTime; // ISO timestamp
  final String endTime; // ISO timestamp
  final String timezone;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? notes;
  final String? trainerNotes;
  final List<dynamic>? rescheduleHistory;
  final String? cancellationReason;
  final String? paymentReference;
  final double? rating;
  final String? feedback;
  final String? ratedAt;
  final String? invoiceUrl;
  final String createdAt;
  final String updatedAt;
  final TrainerInfo? trainer;
  final SessionPlanInfo? sessionPlan;

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
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      feedback: json['feedback'] as String?,
      ratedAt: json['ratedAt'] as String?,
      invoiceUrl: json['invoiceUrl'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      trainer: json['trainer'] != null
          ? TrainerInfo.fromJson(json['trainer'] as Map<String, dynamic>)
          : null,
      sessionPlan: json['sessionPlan'] != null
          ? SessionPlanInfo.fromJson(json['sessionPlan'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Trainer information in booking
class TrainerInfo {
  TrainerInfo({
    required this.id,
    this.fullName,
    this.preferredName,
    this.profilePhoto,
  });

  final String id;
  final String? fullName;
  final String? preferredName;
  final String? profilePhoto;

  factory TrainerInfo.fromJson(Map<String, dynamic> json) {
    return TrainerInfo(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String?,
      preferredName: json['preferredName'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
    );
  }

  String get displayName {
    // Handle empty string for preferredName - use fullName if preferredName is empty
    if (preferredName != null && preferredName!.isNotEmpty) {
      return preferredName!;
    }
    return fullName ?? 'Trainer';
  }
}

/// Session plan information in booking
class SessionPlanInfo {
  SessionPlanInfo({
    required this.id,
    required this.title,
    required this.feeAmount,
    required this.feeCurrency,
    required this.durationMinutes,
  });

  final String id;
  final String title;
  final double feeAmount;
  final String feeCurrency;
  final int durationMinutes;

  factory SessionPlanInfo.fromJson(Map<String, dynamic> json) {
    return SessionPlanInfo(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      feeAmount: (json['feeAmount'] as num).toDouble(),
      feeCurrency: json['feeCurrency'] as String? ?? 'USD',
      durationMinutes: json['durationMinutes'] as int? ?? 60,
    );
  }
}

