import 'package:flutter/foundation.dart';
import '../data/models/session_summary_response_model.dart';
import '../data/repository/booking_repository.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

class SessionDetailsProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  int _rating = 0;
  String _feedback = '';
  SessionSummary? _summary;
  bool _isLoadingSummary = false;
  String? _summaryError;

  int get rating => _rating;
  String get feedback => _feedback;
  bool get hasFeedback => _feedback.trim().isNotEmpty;
  SessionSummary? get summary => _summary;
  bool get isLoadingSummary => _isLoadingSummary;
  String? get summaryError => _summaryError;
  bool get hasSummary => _summary != null;

  void setRating(int rating) {
    _rating = rating;
    notifyListeners();
  }

  void setFeedback(String feedback) {
    _feedback = feedback;
    notifyListeners();
  }

  /// Fetch session summary for a booking
  Future<void> fetchSessionSummary(String? bookingId) async {
    debugPrint(
      'SessionDetailsProvider: fetchSessionSummary called with bookingId: $bookingId',
    );

    if (bookingId == null || bookingId.isEmpty) {
      debugPrint('SessionDetailsProvider: Booking ID is null or empty');
      _summaryError = 'Booking ID is required';
      notifyListeners();
      return;
    }

    debugPrint(
      'SessionDetailsProvider: Starting to fetch summary for bookingId: $bookingId',
    );
    _isLoadingSummary = true;
    _summaryError = null;
    notifyListeners();

    try {
      debugPrint(
        'SessionDetailsProvider: Calling repository.getSessionSummary',
      );
      final result = await _repository.getSessionSummary(bookingId);
      debugPrint('SessionDetailsProvider: Repository call completed');

      await result.when(
        success: (response) async {
          debugPrint(
            'SessionDetailsProvider: Success - Summary received: ${response.summary != null}',
          );
          _summary = response.summary;
          _isLoadingSummary = false;
          _summaryError = null;
          notifyListeners();
        },
        failure: (message, code) {
          debugPrint(
            'SessionDetailsProvider: Failure - Code: $code, Message: $message',
          );
          _isLoadingSummary = false;
          // Handle 404 gracefully - summary might not exist yet
          if (code == 404) {
            _summaryError = null; // Don't show error for missing summary
            _summary = null;
          } else {
            _summaryError = message;
          }
          notifyListeners();
        },
      );
    } catch (e, stackTrace) {
      debugPrint('SessionDetailsProvider: Exception - $e');
      debugPrint('SessionDetailsProvider: StackTrace - $stackTrace');
      _isLoadingSummary = false;
      _summaryError = e.toString().replaceAll('Exception: ', '');
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

      return result.when(
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

      return result.when(
        success: (success) async {
          _isCancelling = false;
          // Refresh summary if needed, or invalidate previous state if we want to reflect changes immediately
          // For now, assume navigation handles leaving the screen or state update happens elsewhere
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
}
