import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../models/get_client_profile_response_model.dart';
import '../models/update_client_profile_request_model.dart';
import '../models/update_client_profile_response_model.dart';

/// API service for client profile operations
class ProfileApiService {
  final ApiHitter _apiHitter = ApiHitter();

  /// Get client profile (standalone profile)
  Future<GetClientProfileResponseModel> getClientProfile() async {
    try {
      final response = await _apiHitter.getApiResponse(
        Endpoints.getClientProfile,
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return GetClientProfileResponseModel.fromJson(responseData);
      } else {
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

  /// Update client profile (standalone profile)
  Future<UpdateClientProfileResponseModel> updateClientProfile(
    UpdateClientProfileRequestModel request,
  ) async {
    try {
      final response = await _apiHitter.getPutApiResponse(
        Endpoints.updateClientProfile,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return UpdateClientProfileResponseModel.fromJson(responseData);
      } else {
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

  /// Delete client account
  Future<bool> deleteAccount({required String reason}) async {
    try {
      final response = await _apiHitter.deleteApiResponse(
        Endpoints.deleteAccount,
        data: {'reason': reason},
      );

      if (response.status) {
        return true;
      } else {
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
