import 'package:flutter/foundation.dart';
import '../data/models/book_session_request_model.dart';
import '../data/repository/trainer_repository.dart';
import '../utils/date_time_utils.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

enum PaymentType {
  paypal,
  applePay,
  creditCard,
}

class PaymentMethodProvider extends ChangeNotifier {
  final TrainerRepository _repository = TrainerRepository();
  
  PaymentType _selectedPaymentType = PaymentType.paypal;
  bool _isBooking = false;
  String? _bookingError;

  PaymentType get selectedPaymentType => _selectedPaymentType;
  bool get isBooking => _isBooking;
  String? get bookingError => _bookingError;

  void selectPaymentType(PaymentType type) {
    _selectedPaymentType = type;
    notifyListeners();
  }

  /// Book a session with the provided booking data
  Future<bool> bookSession({
    required String trainerId,
    required String sessionPlanId,
    required String dateId,
    required String timeSlot,
    required int durationMinutes,
    required List<Map<String, dynamic>> availableDatesData,
    String? notes,
  }) async {
    _isBooking = true;
    _bookingError = null;
    notifyListeners();

    try {
      // Convert availableDatesData back to DateInfo list
      final availableDates = availableDatesData.map((data) {
        final dateTime = DateTime.parse(data['dateId'] as String);
        final dayStr = data['day'] as String?;
        return DateInfo(
          date: dateTime.day.toString(),
          day: dayStr ?? _getDayAbbreviation(dateTime.weekday),
          dateTime: dateTime,
          dateId: data['dateId'] as String,
          sessionPlanId: data['sessionPlanId'] as String,
        );
      }).toList();

      // Convert date and time slot to ISO timestamps
      final timestamps = DateTimeUtils.convertToIsoTimestamps(
        dateId: dateId,
        timeSlot: timeSlot,
        availableDates: availableDates,
        durationMinutes: durationMinutes,
      );

      // Create request model
      final request = BookSessionRequestModel(
        trainerId: trainerId,
        sessionPlanId: sessionPlanId,
        startTime: timestamps['startTime']!,
        endTime: timestamps['endTime']!,
        timezone: 'UTC',
        notes: notes,
      );

      final result = await _repository.bookSession(request);

      return await result.when(
        success: (response) async {
          _isBooking = false;
          _bookingError = null;
          notifyListeners();
          return response.success;
        },
        failure: (message, code) {
          _isBooking = false;
          _bookingError = message;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _isBooking = false;
      _bookingError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  String _getDayAbbreviation(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

