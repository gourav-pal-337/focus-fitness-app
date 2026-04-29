import 'package:flutter/material.dart';

/// Response model for get trainer profile with session plans
class GetTrainerProfileResponseModel {
  GetTrainerProfileResponseModel({
    required this.success,
    required this.trainer,
    required this.sessionPlans,
  });

  final bool success;
  final TrainerProfileInfo trainer;
  final List<SessionPlanModel> sessionPlans;

  factory GetTrainerProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetTrainerProfileResponseModel(
      success: json['success'] as bool? ?? false,
      trainer: json['trainer'] != null
          ? TrainerProfileInfo.fromJson(json['trainer'] as Map<String, dynamic>)
          : throw Exception('Trainer data is required'),
      sessionPlans: json['sessionPlans'] != null
          ? (json['sessionPlans'] as List)
                .map(
                  (item) =>
                      SessionPlanModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}

/// Trainer profile information model
class TrainerProfileInfo {
  TrainerProfileInfo({
    required this.id,
    this.fullName,
    this.preferredName,
    this.profilePhoto,
    this.avgRating,
    required this.ratingCount,
    required this.completedSessionsCount,
    required this.clientCount,
    required this.experience,
    required this.expertiseAreas,
    this.isStripeConnected = false,
    this.isPayPalConnected = false,
    this.vatConfig,
    this.timezone,
  });

  final String id;
  final String? fullName;
  final String? preferredName;
  final String? profilePhoto;
  final double? avgRating;
  final int ratingCount;
  final int completedSessionsCount;
  final int clientCount;
  final int experience;
  final List<String> expertiseAreas;
  final bool isStripeConnected;
  final bool isPayPalConnected;
  final VatConfig? vatConfig;
  final String? timezone;

  factory TrainerProfileInfo.fromJson(Map<String, dynamic> json) {
    debugPrint(
      "connection ${json['isStripeConnected']}  ${json['isPayPalConnected']}",
    );
    return TrainerProfileInfo(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String?,
      preferredName: json['preferredName'] as String?,
      profilePhoto:
          // "",
          json['profilePhoto'] as String?,
      avgRating: json['avgRating'] != null
          ? (json['avgRating'] as num).toDouble()
          : null,
      ratingCount: json['ratingCount'] as int? ?? 0,
      completedSessionsCount: json['completedSessionsCount'] as int? ?? 0,
      clientCount: json['clientCount'] as int? ?? 0,
      experience: json['experience'] as int? ?? 0,
      expertiseAreas: json['expertiseAreas'] != null
          ? List<String>.from(json['expertiseAreas'] as List)
          : [],
      isStripeConnected: json['isStripeConnected'] as bool? ?? false,
      isPayPalConnected: json['isPayPalConnected'] as bool? ?? false,
      vatConfig: json['vatConfig'] != null
          ? VatConfig.fromJson(json['vatConfig'] as Map<String, dynamic>)
          : null,
      timezone: json['timezone'] as String?,
    );
  }
}

class VatConfig {
  VatConfig({
    required this.mode,
    required this.percent,
    required this.showVatLine,
  });

  final String mode;
  final double percent;
  final bool showVatLine;

  factory VatConfig.fromJson(Map<String, dynamic> json) {
    return VatConfig(
      mode: json['mode'] as String? ?? 'na',
      percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
      showVatLine: json['showVatLine'] as bool? ?? false,
    );
  }
}

/// Session plan model
class SessionPlanModel {
  SessionPlanModel({
    required this.id,
    required this.title,
    this.description,
    required this.feeAmount,
    required this.feeCurrency,
    required this.durationMinutes,
    this.packageSessions,
    this.packageValidityDays,
    this.sessionType,
    this.startDate,
    this.endDate,
    this.timeSlots,
    this.timeStart,
    this.timeEnd,
    this.timeRange,
  });

  final String id;
  final String title;
  final String? description;
  final double feeAmount;
  final String feeCurrency;
  final int durationMinutes;
  final int? packageSessions;
  final int? packageValidityDays;
  final String? sessionType;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<TimeSlot>? timeSlots;
  final String? timeStart;
  final String? timeEnd;
  final String? timeRange; // String format: "09:00 AM - 10:00 AM"

  factory SessionPlanModel.fromJson(Map<String, dynamic> json) {
    debugPrint("json platformFeeCurrency: ${json['platformFeeCurrency']}");
    return SessionPlanModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      feeAmount: (json['feeAmount'] as num).toDouble(),
      feeCurrency: json['platformFeeCurrency'] as String? ?? 'USD',
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      packageSessions: json['packageSessions'] as int?,
      packageValidityDays: json['packageValidityDays'] as int?,
      sessionType: json['sessionType'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      timeSlots: json['timeSlots'] != null
          ? (json['timeSlots'] as List)
                .map((item) => TimeSlot.fromJson(item as Map<String, dynamic>))
                .toList()
          : null,
      timeStart: json['timeStart'] as String?,
      timeEnd: json['timeEnd'] as String?,
      timeRange: json['timeRange'] as String?,
    );
  }
}

/// Time slot model
class TimeSlot {
  TimeSlot({required this.startTime, required this.endTime, this.id});

  final String startTime; // Format: '15:09'
  final String endTime; // Format: '16:09'
  final String? id;

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      id: json['_id'] as String?,
    );
  }
}
