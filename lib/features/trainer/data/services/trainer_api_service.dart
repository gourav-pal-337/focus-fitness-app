import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../models/book_session_request_model.dart';
import '../models/book_session_response_model.dart';
import '../models/link_trainer_request_model.dart';
import '../models/link_trainer_response_model.dart';
import '../models/linked_trainer_response_model.dart';
import '../models/trainer_referral_response_model.dart';
import '../models/trainer_profile_response_model.dart';
import '../models/unlink_trainer_response_model.dart';

/// API service for trainer operations
class TrainerApiService {
  final ApiHitter _apiHitter = ApiHitter();

  /// Get trainer by referral code (legacy endpoint)
  /// [referralCode] can be provided as path parameter or query parameter
  Future<TrainerReferralResponseModel> getTrainerByReferralCode(
    String referralCode,
  ) async {
    try {
      // Using query parameter approach as it's more flexible
      final response = await _apiHitter.getApiResponse(
        "${Endpoints.getTrainerByReferralCode}/${referralCode.trim().toUpperCase()}",
        // queryParameters: {
        //   'referralCode': referralCode.trim().toUpperCase(),
        // },
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return TrainerReferralResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              responseData['message'] as String? ??
              responseData['error'] as String? ??
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

  /// Search trainer by referral code (new endpoint with enhanced details)
  /// Requires authentication
  /// Returns list of trainers matching the search query
  Future<TrainerSearchResponseModel> searchTrainerByReferralCode(
    String referralCode,
  ) async {
    try {
      // Using GET with query parameter as per API documentation
      final response = await _apiHitter.getApiResponse(
        Endpoints.searchTrainer,
        queryParameters: {'referralCode': referralCode.trim().toUpperCase()},
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return TrainerSearchResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              (responseData['error'] as String?) ??
              (responseData['message'] as String?) ??
              response.msg;

          throw ApiException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Failed to search trainer',
            statusCode: response.response?.statusCode,
          );
        }
        throw ApiException(
          message: response.msg.isNotEmpty
              ? response.msg
              : 'Failed to search trainer',
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

  /// Get linked trainer for authenticated user
  Future<LinkedTrainerResponseModel> getLinkedTrainer() async {
    try {
      final response = await _apiHitter.getApiResponse(
        Endpoints.getLinkedTrainer,
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return LinkedTrainerResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              (responseData['error'] as String?) ??
              (responseData['message'] as String?) ??
              response.msg;

          throw ApiException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Failed to get linked trainer',
            statusCode: response.response?.statusCode,
          );
        }
        throw ApiException(
          message: response.msg.isNotEmpty
              ? response.msg
              : 'Failed to get linked trainer',
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

  /// Link trainer with referral code
  Future<LinkTrainerResponseModel> linkTrainer(
    LinkTrainerRequestModel request,
  ) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.linkTrainer,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return LinkTrainerResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              responseData['message'] as String? ??
              responseData['error'] as String? ??
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

  /// Get trainer profile with session plans
  /// [trainerId] is the trainer's unique identifier
  Future<GetTrainerProfileResponseModel> getTrainerProfile(
    String trainerId,
  ) async {
    try {
      final response = await _apiHitter.getApiResponse(
        '${Endpoints.getTrainerProfile}/$trainerId',
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return GetTrainerProfileResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              (responseData['error'] as String?) ??
              (responseData['message'] as String?) ??
              response.msg;

          throw ApiException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Failed to get trainer profile',
            statusCode: response.response?.statusCode,
          );
        }
        throw ApiException(
          message: response.msg.isNotEmpty
              ? response.msg
              : 'Failed to get trainer profile',
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

  /// Unlink trainer for authenticated user
  Future<UnlinkTrainerResponseModel> unlinkTrainer() async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.unlinkTrainer,
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return UnlinkTrainerResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              (responseData['error'] as String?) ??
              (responseData['message'] as String?) ??
              response.msg;

          throw ApiException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Failed to unlink trainer',
            statusCode: response.response?.statusCode,
          );
        }
        throw ApiException(
          message: response.msg.isNotEmpty
              ? response.msg
              : 'Failed to unlink trainer',
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

  /// Book a session with a trainer
  Future<BookSessionResponseModel> bookSession(
    BookSessionRequestModel request,
  ) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.bookSession,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return BookSessionResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              (responseData['error'] as String?) ??
              (responseData['message'] as String?) ??
              response.msg;

          throw ApiException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Failed to book session',
            statusCode: response.response?.statusCode,
          );
        }
        throw ApiException(
          message: response.msg.isNotEmpty
              ? response.msg
              : 'Failed to book session',
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
