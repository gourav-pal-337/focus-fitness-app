import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../../../../features/authentication/data/models/get_user_response_model.dart';

/// API service for user operations
class UserApiService {
  final ApiHitter _apiHitter = ApiHitter();

  /// Get current user details
  Future<GetUserResponseModel> getUserDetails() async {
    try {
      final response = await _apiHitter.getApiResponse(
        Endpoints.getUserDetails,
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return GetUserResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              responseData['error'] as String? ??
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

  /// Update FCM Token
  Future<bool> updateFcmToken({
    required String token,
    required String platform,
  }) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.fcmToken,

        data: {'token': token, 'platform': platform},
      );

      if (response.status) {
        return true;
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
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
