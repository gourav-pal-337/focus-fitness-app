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
import '../services/auth_api_service.dart';

/// Result type for API operations
sealed class Result<T> {}

class Success<T> extends Result<T> {
  Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  Failure(this.message, {this.code});
  final String message;
  final int? code;
}

/// Repository for authentication operations
class AuthRepository {
  final AuthApiService _apiService = AuthApiService();

  /// Register user with email
  Future<Result<RegisterResponseModel>> registerWithEmail(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await _apiService.registerWithEmail(request);
      return Success(response);
    } on ApiException catch (e) {
      print("eee: ${e.message}");
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Login user with email
  Future<Result<LoginResponseModel>> loginWithEmail(
    LoginRequestModel request,
  ) async {
    try {
      final response = await _apiService.loginWithEmail(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Login user with Firebase (Google/Apple)
  Future<Result<LoginResponseModel>> firebaseLogin(
    FirebaseLoginRequestModel request,
  ) async {
    try {
      final response = await _apiService.firebaseLogin(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Request password reset
  Future<Result<PasswordResetRequestResponseModel>> requestPasswordReset(
    PasswordResetRequestModel request,
  ) async {
    try {
      final response = await _apiService.requestPasswordReset(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Confirm password reset
  Future<Result<PasswordResetConfirmResponseModel>> confirmPasswordReset(
    PasswordResetConfirmModel request,
  ) async {
    try {
      final response = await _apiService.confirmPasswordReset(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    try {
      final response = await _apiService.sendOtp(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<SendOtpResponseModel>> sendEmailOtp(String email) async {
    return sendOtp(
      SendOtpRequestModel(email: email, purpose: 'verification', role: 'client'),
    );
  }

  Future<Result<SendOtpResponseModel>> sendPhoneOtp(
    String countryCode,
    String phone,
  ) async {
    return sendOtp(
      SendOtpRequestModel(
        countryCode: countryCode,
        phone: phone,
        purpose: 'verification',
        role: 'client',
      ),
    );
  }

  Future<Result<LoginResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    try {
      final response = await _apiService.verifyOtp(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<LoginResponseModel>> verifyEmailOtp(
    String email,
    String otp,
  ) async {
    return verifyOtp(
      VerifyOtpRequestModel(
        email: email,
        code: otp,
        purpose: 'verification',
        role: 'client',
      ),
    );
  }

  Future<Result<LoginResponseModel>> verifyPhoneOtp(
    String countryCode,
    String phone,
    String otp,
  ) async {
    return verifyOtp(
      VerifyOtpRequestModel(
        countryCode: countryCode,
        phone: phone,
        code: otp,
        purpose: 'verification',
        role: 'client',
      ),
    );
  }

  /// Send TFA OTP
  Future<Result<bool>> sendTfaOtp(String userId, String phone, String phoneCountry) async {
    try {
      final response = await _apiService.sendTfaOtp(userId, phone, phoneCountry);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  /// Verify TFA OTP
  Future<Result<LoginResponseModel>> verifyTfaOtp(
    String userId,
    String phone,
    String phoneCountry,
    String otp,
  ) async {
    try {
      final response = await _apiService.verifyTfaOtp(
        userId,
        phone,
        phoneCountry,
        otp,
      );
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
  /// Disable TFA
  Future<Result<bool>> disableTfa() async {
    try {
      final response = await _apiService.disableTfa();
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
}

/// Extension for Result type pattern matching
extension ResultExtension<T> on Result<T> {
  Future<R> when<R>({
    required Future<R> Function(T data) success,
    required R Function(String message, int? code) failure,
  }) async {
    return switch (this) {
      Success(data: final data) => await success(data),
      Failure(message: final message, code: final code) => failure(
        message,
        code,
      ),
    };
  }
}
