import 'package:flutter/foundation.dart';
import '../data/models/booking_payment_response_model.dart';
import '../data/models/reschedule_models.dart';

import '../data/repository/booking_repository.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

class SessionDetailsProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  int _rating = 0;
  String _feedback = '';
  BookingPayment? _payment;
  bool _isLoadingPayment = false;
  String? _paymentError;

  int get rating => _rating;
  String get feedback => _feedback;
  bool get hasFeedback => _feedback.trim().isNotEmpty;
  BookingPayment? get payment => _payment;
  bool get isLoadingPayment => _isLoadingPayment;
  String? get paymentError => _paymentError;
  bool get hasPayment => _payment != null;

  void setRating(int rating) {
    _rating = rating;
    notifyListeners();
  }

  void setFeedback(String feedback) {
    _feedback = feedback;
    notifyListeners();
  }

  /// Fetch payment details for a booking
  Future<void> fetchBookingPayment(String? bookingId) async {
    debugPrint(
      'SessionDetailsProvider: fetchBookingPayment called with bookingId: $bookingId',
    );

    if (bookingId == null || bookingId.isEmpty) {
      debugPrint('SessionDetailsProvider: Booking ID is null or empty');
      _paymentError = 'Booking ID is required';
      notifyListeners();
      return;
    }

    _isLoadingPayment = true;
    _paymentError = null;
    notifyListeners();

    try {
      final result = await _repository.getBookingPayment(bookingId);

      await result.when(
        success: (response) async {
          _payment = response.payment;
          _isLoadingPayment = false;
          _paymentError = null;
          notifyListeners();
        },
        failure: (message, code) {
          _isLoadingPayment = false;
          _paymentError = message;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoadingPayment = false;
      _paymentError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  bool _isSubmittingFeedback = false;

  bool get isSubmittingFeedback => _isSubmittingFeedback;

  /// Submit rating and feedback
  Future<bool> submitFeedback(String bookingId) async {
    if (_rating == 0) {
      // Should validation be handled here or UI? UI usually prevents calling if invalid, but good to check.
      // But for now let's assume UI handles it or we return false/throw.
      return false;
    }

    _isSubmittingFeedback = true;
    notifyListeners();

    try {
      final result = await _repository.rateSession(
        bookingId: bookingId,
        rating: _rating,
        feedback: _feedback,
      );

      return await result.when(
        success: (success) async {
          _isSubmittingFeedback = false;
          notifyListeners();
          return success;
        },
        failure: (message, code) {
          _isSubmittingFeedback = false;
          debugPrint(
            'SessionDetailsProvider: Submit Feedback failed: $message',
          );
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _isSubmittingFeedback = false;
      debugPrint('SessionDetailsProvider: Submit Feedback exception: $e');
      notifyListeners();
      return false;
    }
  }

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  /// Cancel a session
  Future<bool> cancelSession(String bookingId, {String? reason}) async {
    _isCancelling = true;
    notifyListeners();

    try {
      final result = await _repository.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );

      return await result.when(
        success: (success) async {
          _isCancelling = false;
          notifyListeners();
          return success;
        },
        failure: (message, code) {
          _isCancelling = false;
          debugPrint('SessionDetailsProvider: Cancel Session failed: $message');
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _isCancelling = false;
      debugPrint('SessionDetailsProvider: Cancel Session exception: $e');
      notifyListeners();
      return false;
    }
  }

  /// Reschedule related state
  List<DayAvailability> _availability = [];
  bool _isLoadingAvailability = false;
  String? _availabilityError;
  bool _isRescheduling = false;

  List<DayAvailability> get availability => _availability;
  bool get isLoadingAvailability => _isLoadingAvailability;
  String? get availabilityError => _availabilityError;
  bool get isRescheduling => _isRescheduling;

  /// Fetch reschedule availability
  Future<void> fetchRescheduleAvailability(String bookingId) async {
    _isLoadingAvailability = true;
    _availabilityError = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final from = now.toIso8601String().split('T').first;
      final to = now
          .add(const Duration(days: 14))
          .toIso8601String()
          .split('T')
          .first;

      final result = await _repository.getRescheduleAvailability(
        bookingId: bookingId,
        from: from,
        to: to,
      );

      await result.when(
        success: (response) async {
          // Group flat slots by date
          final Map<String, List<RescheduleSlot>> grouped = {};
          for (final slot in response.availableSlots) {
            if (!grouped.containsKey(slot.date)) {
              grouped[slot.date] = [];
            }
            grouped[slot.date]!.add(slot);
          }

          // Convert to List<DayAvailability>
          _availability = grouped.entries
              .map((e) => DayAvailability(date: e.key, availableSlots: e.value))
              .toList();

          // Sort by date just in case
          _availability.sort((a, b) => a.date.compareTo(b.date));

          _isLoadingAvailability = false;
          notifyListeners();
        },
        failure: (message, code) {
          _isLoadingAvailability = false;
          _availabilityError = message;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoadingAvailability = false;
      _availabilityError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Reschedule a booking
  Future<bool> rescheduleBooking({
    required String bookingId,
    required String startTime,
    required String endTime,
    String? reason,
  }) async {
    _isRescheduling = true;
    notifyListeners();

    try {
      final request = RescheduleRequestModel(
        startTime: startTime,
        endTime: endTime,
        reason: reason,
      );

      final result = await _repository.rescheduleBooking(
        bookingId: bookingId,
        request: request,
      );

      return await result.when(
        success: (response) async {
          _isRescheduling = false;
          notifyListeners();
          return response.success;
        },
        failure: (message, code) {
          _isRescheduling = false;
          debugPrint(
            'SessionDetailsProvider: Reschedule Booking failed: $message',
          );
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _isRescheduling = false;
      debugPrint('SessionDetailsProvider: Reschedule Booking exception: $e');
      notifyListeners();
      return false;
    }
  }
}
