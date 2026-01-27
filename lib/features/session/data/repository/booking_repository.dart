import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show Result, Success, Failure;
import '../models/get_bookings_response_model.dart';
import '../models/session_summary_response_model.dart';
import '../services/booking_api_service.dart';

/// Repository for booking operations
class BookingRepository {
  final BookingApiService _apiService = BookingApiService();

  /// Get client bookings with optional filters
  Future<Result<GetBookingsResponseModel>> getClientBookings({
    String? status,
    String? from,
    String? to,
  }) async {
    try {
      final response = await _apiService.getClientBookings(
        status: status,
        from: from,
        to: to,
      );
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Get session summary for a specific booking
  Future<Result<SessionSummaryResponseModel>> getSessionSummary(
    String bookingId,
  ) async {
    try {
      final response = await _apiService.getSessionSummary(bookingId);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Rate a completed session
  Future<Result<bool>> rateSession({
    required String bookingId,
    required int rating,
    String? feedback,
  }) async {
    try {
      final response = await _apiService.rateSession(
        bookingId: bookingId,
        rating: rating,
        feedback: feedback,
      );
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Cancel a completed session
  Future<Result<bool>> cancelBooking({
    required String bookingId,
    String? reason,
  }) async {
    try {
      final response = await _apiService.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
}
