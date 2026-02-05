import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../exceptions/api_exception.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/password_reset_request_model.dart';
import '../models/password_reset_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/firebase_login_request_model.dart';
import '../models/send_otp_request_model.dart';
import '../models/send_otp_response_model.dart';
import '../models/verify_otp_request_model.dart';

/// API service for authentication operations
class AuthApiService {
  final ApiHitter _apiHitter = ApiHitter();

  /// Register user with email and password
  Future<RegisterResponseModel> registerWithEmail(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.registerEmail,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return RegisterResponseModel.fromJson(responseData);
      } else {
        // Handle error response with validation errors
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errors = responseData['errors'] as Map<String, dynamic>?;
          // Try to extract error message from various possible fields
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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

  /// Login user with email and password
  Future<LoginResponseModel> loginWithEmail(LoginRequestModel request) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.loginEmail,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return LoginResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          final errors = responseData['errors'] as Map<String, dynamic>?;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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

  /// Login user with Firebase (Google/Apple)
  Future<LoginResponseModel> firebaseLogin(
    FirebaseLoginRequestModel request,
  ) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.firebaseLogin,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return LoginResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to extract error message from various possible fields
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          final errors = responseData['errors'] as Map<String, dynamic>?;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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

  /// Request password reset
  Future<PasswordResetRequestResponseModel> requestPasswordReset(
    PasswordResetRequestModel request,
  ) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.forgotPassword,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return PasswordResetRequestResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          final errors = responseData['errors'] as Map<String, dynamic>?;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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

  /// Confirm password reset
  Future<PasswordResetConfirmResponseModel> confirmPasswordReset(
    PasswordResetConfirmModel request,
  ) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.resetPassword,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return PasswordResetConfirmResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          final errors = responseData['errors'] as Map<String, dynamic>?;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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

  /// Send OTP to phone
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.sendOtp,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return SendOtpResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          final errors = responseData['errors'] as Map<String, dynamic>?;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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

  /// Verify OTP
  Future<LoginResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.verifyOtp,
        data: request.toJson(),
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return LoginResponseModel.fromJson(responseData);
      } else {
        // Handle error response
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          final errors = responseData['errors'] as Map<String, dynamic>?;
          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
            errors: errors,
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
