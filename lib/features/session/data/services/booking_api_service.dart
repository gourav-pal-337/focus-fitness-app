import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../models/get_bookings_response_model.dart';
import '../models/session_summary_response_model.dart';

/// API service for booking operations
class BookingApiService {
  final ApiHitter _apiHitter = ApiHitter();

  /// Get client bookings with optional filters
  Future<GetBookingsResponseModel> getClientBookings({
    String? status,
    String? from,
    String? to,
  }) async {
    try {
      // Build query parameters
      final Map<String, dynamic> queryParams = {};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (from != null && from.isNotEmpty) {
        queryParams['from'] = from;
      }
      if (to != null && to.isNotEmpty) {
        queryParams['to'] = to;
      }

      final response = await _apiHitter.getApiResponse(
        Endpoints.getClientBookings,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return GetBookingsResponseModel.fromJson(responseData);
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage = responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
          );
        }

        throw ApiException(
          message: response.msg,
          statusCode: response.response?.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString().replaceAll('Exception: ', ''),
        statusCode: 500,
      );
    }
  }

  /// Get session summary for a specific booking
  Future<SessionSummaryResponseModel> getSessionSummary(String bookingId) async {
    try {
      final endpoint = Endpoints.getSessionSummary(bookingId);
      debugPrint('BookingApiService: Calling getSessionSummary with endpoint: $endpoint');
      final response = await _apiHitter.getApiResponse(endpoint);
      debugPrint('BookingApiService: Response status: ${response.status}');

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return SessionSummaryResponseModel.fromJson(responseData);
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage = responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
          );
        }

        throw ApiException(
          message: response.msg,
          statusCode: response.response?.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString().replaceAll('Exception: ', ''),
        statusCode: 500,
      );
    }
  }
}

