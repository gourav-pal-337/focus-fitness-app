import 'package:flutter/foundation.dart';
import '../data/models/book_session_request_model.dart';
import '../data/repository/trainer_repository.dart';
import '../utils/date_time_utils.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;
import '../data/models/payment_booking_models.dart';
import '../../../core/service/local_storage_service.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

enum PaymentType { paypal, applePay, creditCard }

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
    String? mode,
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
          day: dayStr ?? DateTimeUtils.getDayAbbreviation(dateTime.weekday),
          month: DateTimeUtils.getMonthAbbreviation(dateTime.month),
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

      // Get timezone
      String? timezone = await LocalStorageService.getTimezone();
      if (timezone == null || timezone.isEmpty) {
        final info = await FlutterTimezone.getLocalTimezone();
        timezone = info.identifier;
      }

      // Create request model
      final request = BookSessionRequestModel(
        trainerId: trainerId,
        sessionPlanId: sessionPlanId,
        startTime: timestamps['startTime']!,
        endTime: timestamps['endTime']!,
        timezone: timezone ?? 'UTC',
        notes: notes,
        mode: mode,
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

  /// Initiate payment for a session booking
  Future<InitiatePaymentResponseModel?> initiatePayment({
    required String trainerId,
    required String sessionPlanId,
    required String dateId,
    required String timeSlot,
    required int durationMinutes,
    required List<Map<String, dynamic>> availableDatesData,
    required String provider,
    double? serviceFee,
    double? vatAmount,
    double? totalAmount,
    double? platformFeeValue,
    String? platformFeeType,
    double? vatTaxPercent,
    String? notes,
    String? mode,
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
          day: dayStr ?? DateTimeUtils.getDayAbbreviation(dateTime.weekday),
          month: DateTimeUtils.getMonthAbbreviation(dateTime.month),
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

      // Get timezone
      String? timezone = await LocalStorageService.getTimezone();
      if (timezone == null || timezone.isEmpty) {
        final info = await FlutterTimezone.getLocalTimezone();
        timezone = info.identifier;
      }

      // Create request model
      final request = InitiatePaymentRequestModel(
        trainerId: trainerId,
        sessionPlanId: sessionPlanId,
        startTime: timestamps['startTime']!,
        endTime: timestamps['endTime']!,
        provider: provider,
        timezone: timezone ?? 'UTC',
        notes: notes,
        serviceFee: serviceFee,
        vatAmount: vatAmount,
        totalAmount: totalAmount,
        platformFeeValue: platformFeeValue,
        platformFeeType: platformFeeType,
        vatTaxPercent: vatTaxPercent,
        mode: mode,
      );

      final result = await _repository.initiateSessionPayment(request);

      return await result.when(
        success: (response) async {
          _isBooking = false;
          _bookingError = null;
          notifyListeners();
          return response;
        },
        failure: (message, code) {
          _isBooking = false;
          _bookingError = message;
          notifyListeners();
          return null;
        },
      );
    } catch (e) {
      _isBooking = false;
      _bookingError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  /// Confirm payment for a session booking
  Future<ConfirmPaymentResponseModel?> confirmPayment({
    required String paymentId,
    required String provider,
    String? providerPaymentId,
    String? providerOrderId,
  }) async {
    _isBooking = true;
    _bookingError = null;
    notifyListeners();

    try {
      final request = ConfirmPaymentRequestModel(
        paymentId: paymentId,
        provider: provider,
        providerPaymentId: providerPaymentId,
        providerOrderId: providerOrderId,
      );

      final result = await _repository.confirmSessionPayment(request);

      return await result.when(
        success: (response) async {
          _isBooking = false;
          _bookingError = null;
          notifyListeners();
          return response;
        },
        failure: (message, code) {
          _isBooking = false;
          _bookingError = message;
          notifyListeners();
          return null;
        },
      );
    } catch (e) {
      _isBooking = false;
      _bookingError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  /// Verify payment status via payment intent ID or order ID
  Future<Map<String, dynamic>?> verifyPaymentStatus(
    String id, {
    bool isPaypal = false,
  }) async {
    _isBooking = true;
    _bookingError = null;
    notifyListeners();

    try {
      final result = await _repository.verifyPaymentStatus(
        id,
        isPaypal: isPaypal,
      );

      return await result.when(
        success: (response) async {
          _isBooking = false;
          _bookingError = null;
          notifyListeners();
          return response;
        },
        failure: (message, code) {
          _isBooking = false;
          _bookingError = message;
          notifyListeners();
          return null;
        },
      );
    } catch (e) {
      _isBooking = false;
      _bookingError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }


}
