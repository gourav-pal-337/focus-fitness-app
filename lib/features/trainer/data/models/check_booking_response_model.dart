class CheckBookingResponseModel {
  CheckBookingResponseModel({
    required this.success,
    required this.hasBooking,
    this.source,
    this.bookingId,
    this.status,
  });

  final bool success;
  final bool hasBooking;
  final String? source;
  final String? bookingId;
  final String? status;

  factory CheckBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckBookingResponseModel(
      success: json['success'] as bool? ?? false,
      hasBooking: json['hasBooking'] as bool? ?? false,
      source: json['source'] as String?,
      bookingId: json['bookingId'] as String?,
      status: json['status'] as String?,
    );
  }
}
