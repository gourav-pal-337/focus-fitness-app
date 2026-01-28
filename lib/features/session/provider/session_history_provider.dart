import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../data/models/booking_model.dart';
import '../data/repository/booking_repository.dart';
import '../widgets/session_card.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

enum SessionTab { all, upcoming, past, cancelled }

class SessionHistoryProvider extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();

  SessionTab _selectedTab = SessionTab.all;
  List<BookingModel> _allBookings = [];
  bool _isLoading = false;
  String? _error;

  SessionTab get selectedTab => _selectedTab;
  List<BookingModel> get allBookings => _allBookings;
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
    notifyListeners();
    fetchBookings();
  }

  /// Fetch bookings from API
  Future<void> fetchBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Map tab to API status filter
      String? statusFilter;
      switch (_selectedTab) {
        case SessionTab.upcoming:
          statusFilter = 'confirmed';
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
    // Parse start time
    final startTime = DateTime.parse(booking.startTime);

    // Format date
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr =
        '${months[startTime.month - 1]} ${startTime.day}, ${startTime.year}';

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
    final trainerName = booking.trainer?.displayName ?? 'Trainer';

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
      invoiceUrl: booking.invoiceUrl,
      bookingId: booking.id,
      booking: booking,
    );
  }

  /// Refresh bookings
  Future<void> refresh() async {
    await fetchBookings();
  }
}
