import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../data/models/booking_model.dart';
import '../data/repository/booking_repository.dart';
import '../widgets/session_card.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;
import '../../../../core/utils/time_utils.dart';

enum SessionTab { all, upcoming, past, cancelled }

class SessionHistoryProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  SessionTab _selectedTab = SessionTab.all;
  List<BookingModel> _allBookings = [];
  List<BookingModel> _pendingCompletionBookings = [];
  bool _isLoading = false;
  String? _error;

  SessionTab get selectedTab => _selectedTab;
  List<BookingModel> get allBookings => _allBookings;
  List<BookingModel> get pendingCompletionBookings =>
      _pendingCompletionBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get filtered bookings based on selected tab
  List<BookingModel> get filteredBookings {
    return _allBookings;
  }

  /// Get SessionData list for UI
  List<SessionData> get sessions {
    return filteredBookings
        .map((booking) => _mapBookingToSessionData(booking))
        .toList();
  }

  void selectTab(SessionTab tab) {
    if (_selectedTab == tab) return;
    _selectedTab = tab;
    // Clear data and set loading to prevent showing stale results
    _allBookings = [];
    _isLoading = true;
    notifyListeners();
    fetchBookings();
  }

  /// Fetch bookings from API
  Future<void> fetchBookings({bool force = false}) async {
    if (!force && _allBookings.isNotEmpty) {
      // Background update
    } else {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      // Map tab to API status filter
      String? statusFilter;
      switch (_selectedTab) {
        case SessionTab.upcoming:
          statusFilter = 'pending';
          break;
        case SessionTab.past:
          statusFilter = 'completed';
          break;
        case SessionTab.cancelled:
          statusFilter = 'cancelled';
          break;
        case SessionTab.all:
          statusFilter = null;
          break;
      }

      final result = await _repository.getClientBookings(status: statusFilter);

      await result.when(
        success: (response) async {
          _allBookings = response.bookings;
          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        failure: (message, code) {
          _isLoading = false;
          _error = message;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Map BookingModel to SessionData
  SessionData _mapBookingToSessionData(BookingModel booking) {
    // Format date and time using TimeUtils
    final dateStr = TimeUtils.formatToLocalDate(
      booking.startTime,
      format: 'MMM dd, yyyy',
    );
    final timeStr = TimeUtils.formatToLocalTimeRange(
      booking.startTime,
      booking.endTime,
      showfulltime: false,
    );

    // Determine status
    SessionStatus status;
    switch (booking.status.toLowerCase()) {
      case 'cancelled':
        status = SessionStatus.cancelled;
        break;
      case 'completed':
        status = SessionStatus.completed;
        break;
      case 'confirmed':
      case 'pending':
      default:
        status = SessionStatus.upcoming;
        break;
    }

    // Get trainer name and image
    final trainerName = booking.trainer?.fullName ?? 'Trainer';

    // Handle profile photo URL
    String trainerImageUrl = booking.trainer?.profilePhoto ?? '';
    if (trainerImageUrl.isNotEmpty && trainerImageUrl.startsWith('/')) {
      // Extract base URL from Endpoints.baseUrl (remove /api/mobile)
      final baseUrl = Endpoints.baseUrl.replaceAll('/api/mobile', '');
      trainerImageUrl = '$baseUrl$trainerImageUrl';
    }

    // Get session type and duration
    final sessionType = booking.sessionPlan?.title ?? 'Session';
    final durationMinutes = booking.sessionPlan?.durationMinutes ?? 60;
    final duration = '${durationMinutes}min';

    return SessionData(
      trainerName: trainerName,
      trainerImageUrl: trainerImageUrl,
      sessionType: sessionType,
      duration: duration,
      status: status,
      date: dateStr,
      startTime: timeStr,
      invoiceUrl: booking.invoiceUrl,
      bookingId: booking.id,
      booking: booking,
    );
  }

  /// Refresh bookings
  Future<void> refresh() async {
    await Future.wait([fetchBookings(), fetchPendingCompletionBookings()]);
  }

  /// Fetch bookings that are pending completion confirmation
  Future<void> fetchPendingCompletionBookings() async {
    try {
      final result = await _repository.getPendingCompletionBookings();

      await result.when(
        success: (response) async {
          _pendingCompletionBookings = response.bookings;
          notifyListeners();
        },
        failure: (message, code) {
          debugPrint('Error fetching pending completions: $message');
        },
      );
    } catch (e) {
      debugPrint('Exception fetching pending completions: $e');
    }
  }

  /// Update booking status (e.g. to completed)
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      final result = await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );

      return await result.when(
        success: (success) async {
          if (success) {
            // Remove from pending list if it was there
            _pendingCompletionBookings.removeWhere((b) => b.id == bookingId);
            notifyListeners();
            // Refresh main bookings list
            fetchBookings();
          }
          return success;
        },
        failure: (message, code) {
          debugPrint('Error updating booking status: $message');
          return false;
        },
      );
    } catch (e) {
      debugPrint('Exception updating booking status: $e');
      return false;
    }
  }

  /// Complete a booking
  Future<bool> completeBooking(String bookingId) async {
    try {
      final result = await _repository.completeBooking(bookingId);

      return await result.when(
        success: (success) async {
          if (success) {
            // Remove from pending list if it was there
            _pendingCompletionBookings.removeWhere((b) => b.id == bookingId);
            notifyListeners();
            // Refresh main bookings list
            fetchBookings();
          }
          return success;
        },
        failure: (message, code) {
          debugPrint('Error completing booking: $message');
          return false;
        },
      );
    } catch (e) {
      debugPrint('Exception completing booking: $e');
      return false;
    }
  }
}
