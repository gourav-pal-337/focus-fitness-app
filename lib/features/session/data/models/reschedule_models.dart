import '../../../trainer/data/models/trainer_profile_response_model.dart';

/// Models for rescheduling a booking
class RescheduleAvailabilityResponseModel {
  RescheduleAvailabilityResponseModel({
    required this.success,
    this.timezone,
    required this.availableSlots,
    this.trainer,
    this.sessionPlans,
  });

  final bool success;
  final String? timezone;
  final List<RescheduleSlot> availableSlots;
  final TrainerProfileInfo? trainer;
  final List<SessionPlanModel>? sessionPlans;

  factory RescheduleAvailabilityResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RescheduleAvailabilityResponseModel(
      success: json['success'] as bool? ?? false,
      timezone: json['timezone'] as String?,
      availableSlots: json['availableSlots'] != null
          ? (json['availableSlots'] as List)
                .map(
                  (item) =>
                      RescheduleSlot.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      trainer: json['trainer'] != null
          ? TrainerProfileInfo.fromJson(json['trainer'] as Map<String, dynamic>)
          : null,
      sessionPlans: json['sessionPlans'] != null
          ? (json['sessionPlans'] as List)
                .map(
                  (item) =>
                      SessionPlanModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }
}

class RescheduleSlot {
  RescheduleSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
    this.startMinutes,
    this.endMinutes,
    this.source,
    this.planId,
  });

  final String date; // Format: '2026-03-11'
  final String startTime; // ISO string
  final String endTime; // ISO string
  final int? startMinutes;
  final int? endMinutes;
  final String? source;
  final String? planId;

  factory RescheduleSlot.fromJson(Map<String, dynamic> json) {
    return RescheduleSlot(
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      startMinutes: json['startMinutes'] as int?,
      endMinutes: json['endMinutes'] as int?,
      source: json['source'] as String?,
      planId: json['planId'] as String?,
    );
  }
}

class DayAvailability {
  DayAvailability({required this.date, required this.availableSlots});

  final String date;
  final List<RescheduleSlot> availableSlots;
}

class RescheduleRequestModel {
  RescheduleRequestModel({
    required this.startTime,
    required this.endTime,
    this.reason,
  });

  final String startTime;
  final String endTime;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
    };
  }
}

class RescheduleResponseModel {
  RescheduleResponseModel({required this.success, this.message});

  final bool success;
  final String? message;

  factory RescheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return RescheduleResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
