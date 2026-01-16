import 'booking_model.dart';

/// Response model for get client bookings
class GetBookingsResponseModel {
  GetBookingsResponseModel({
    required this.success,
    required this.bookings,
  });

  final bool success;
  final List<BookingModel> bookings;

  factory GetBookingsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetBookingsResponseModel(
      success: json['success'] as bool? ?? false,
      bookings: json['bookings'] != null
          ? (json['bookings'] as List)
              .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

