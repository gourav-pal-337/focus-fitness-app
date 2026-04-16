class NextAvailableSlotResponseModel {
  NextAvailableSlotResponseModel({
    required this.success,
    this.availableSlot,
    this.message,
  });

  final bool success;
  final AvailableSlotModel? availableSlot;
  final String? message;

  factory NextAvailableSlotResponseModel.fromJson(Map<String, dynamic> json) {
    return NextAvailableSlotResponseModel(
      success: json['success'] as bool? ?? false,
      availableSlot: json['availableSlot'] != null
          ? AvailableSlotModel.fromJson(json['availableSlot'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }
}

class AvailableSlotModel {
  AvailableSlotModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.startMinutes,
    required this.endMinutes,
    required this.source,
    this.planId,
  });

  final String date;
  final String startTime;
  final String endTime;
  final int startMinutes;
  final int endMinutes;
  final String source;
  final String? planId;

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      startMinutes: json['startMinutes'] as int? ?? 0,
      endMinutes: json['endMinutes'] as int? ?? 0,
      source: json['source'] as String? ?? '',
      planId: json['planId'] as String?,
    );
  }
}
