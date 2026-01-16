import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/service/local_storage_service.dart';
import '../data/models/password_reset_request_model.dart';
import '../data/models/password_reset_response_model.dart';
import '../data/repository/auth_repository.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  // Email Entry
  String _resetEmail = '';
  String get resetEmail => _resetEmail;
  bool get canProceedWithEmail {
    final email = _resetEmail.trim();
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  void updateResetEmail(String value) {
    _resetEmail = value;
    notifyListeners();
  }

  // Email Verification Code
  String _emailCode = '';
  
  String get emailCode => _emailCode;
  bool get canProceedWithEmailCode => _emailCode.length == 6;

  void updateEmailCode(String value) {
    _emailCode = value;
    notifyListeners();
  }

  void clearEmailCode() {
    _emailCode = '';
    notifyListeners();
  }

  // New Password Entry
  String _newPassword = '';
  String _confirmPassword = '';
  
  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  
  bool get canProceedWithPassword {
    return _newPassword.trim().isNotEmpty &&
        _confirmPassword.trim().isNotEmpty &&
        _newPassword == _confirmPassword;
  }

  void updateNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  // Password reset request state
  bool _isRequestingReset = false;
  bool _isResetRequested = false;
  String? _resetRequestError;
  int? _resetRequestErrorCode;
  String? _resetCodeExpiresAt;

  bool get isRequestingReset => _isRequestingReset;
  bool get isResetRequested => _isResetRequested;
  String? get resetRequestError => _resetRequestError;
  int? get resetRequestErrorCode => _resetRequestErrorCode;
  String? get resetCodeExpiresAt => _resetCodeExpiresAt;

  /// Request password reset code
  Future<bool> requestPasswordReset() async {
    if (!canProceedWithEmail) {
      _resetRequestError = 'Please enter a valid email address.';
      _resetRequestErrorCode = 400;
      notifyListeners();
      return false;
    }

    _isRequestingReset = true;
    _resetRequestError = null;
    _resetRequestErrorCode = null;
    notifyListeners();

    try {
      final request = PasswordResetRequestModel(email: _resetEmail);
      final result = await _repository.requestPasswordReset(request);

      return await result.when(
        success: (response) async {
          _isResetRequested = true;
          _resetCodeExpiresAt = response.expiresAt;
          _isRequestingReset = false;
          _resetRequestError = null;
          _resetRequestErrorCode = null;
          notifyListeners();
          return true;
        },
        failure: (message, code) {
          _resetRequestError = message;
          _resetRequestErrorCode = code;
          _isRequestingReset = false;
          _isResetRequested = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _resetRequestError = e.toString().replaceAll('Exception: ', '');
      _resetRequestErrorCode = 500;
      _isRequestingReset = false;
      _isResetRequested = false;
      notifyListeners();
      return false;
    }
  }

  // Password reset confirm state
  bool _isConfirmingReset = false;
  bool _isResetConfirmed = false;
  String? _resetConfirmError;
  int? _resetConfirmErrorCode;
  PasswordResetConfirmResponseModel? _resetConfirmResponse;

  bool get isConfirmingReset => _isConfirmingReset;
  bool get isResetConfirmed => _isResetConfirmed;
  String? get resetConfirmError => _resetConfirmError;
  int? get resetConfirmErrorCode => _resetConfirmErrorCode;
  PasswordResetConfirmResponseModel? get resetConfirmResponse =>
      _resetConfirmResponse;

  /// Confirm password reset
  Future<bool> confirmPasswordReset() async {
    if (!canProceedWithEmailCode) {
      _resetConfirmError = 'Please enter the 6-digit code.';
      _resetConfirmErrorCode = 400;
      notifyListeners();
      return false;
    }

    if (!canProceedWithPassword) {
      _resetConfirmError = 'Passwords do not match.';
      _resetConfirmErrorCode = 400;
      notifyListeners();
      return false;
    }

    if (_newPassword.trim().length < 6) {
      _resetConfirmError = 'Password must be at least 6 characters long.';
      _resetConfirmErrorCode = 400;
      notifyListeners();
      return false;
    }

    _isConfirmingReset = true;
    _resetConfirmError = null;
    _resetConfirmErrorCode = null;
    notifyListeners();

    try {
      final request = PasswordResetConfirmModel(
        email: _resetEmail,
        code: emailCode,
        newPassword: _newPassword,
      );

      final result = await _repository.confirmPasswordReset(request);

      return await result.when(
        success: (response) async {
          _resetConfirmResponse = response;

          // Store tokens in secure storage
          await _storeResetTokens(response);

          _isResetConfirmed = true;
          _isConfirmingReset = false;
          _resetConfirmError = null;
          _resetConfirmErrorCode = null;
          notifyListeners();
          return true;
        },
        failure: (message, code) {
          _resetConfirmError = message;
          _resetConfirmErrorCode = code;
          _isConfirmingReset = false;
          _isResetConfirmed = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _resetConfirmError = e.toString().replaceAll('Exception: ', '');
      _resetConfirmErrorCode = 500;
      _isConfirmingReset = false;
      _isResetConfirmed = false;
      notifyListeners();
      return false;
    }
  }

  /// Store authentication tokens from password reset response
  Future<void> _storeResetTokens(
    PasswordResetConfirmResponseModel response,
  ) async {
    // Store access token (check multiple possible fields)
    if (response.accessToken != null) {
      await LocalStorageService.setToken(response.accessToken!);
    } else if (response.token != null) {
      await LocalStorageService.setToken(response.token!);
    } else if (response.tokens?.accessToken != null) {
      await LocalStorageService.setToken(response.tokens!.accessToken);
    }

    // Store refresh token if available
    if (response.refreshToken != null) {
      await LocalStorageService.setRefreshToken(response.refreshToken!);
    } else if (response.tokens?.refreshToken != null) {
      await LocalStorageService.setRefreshToken(response.tokens!.refreshToken);
    }

    // Store user ID if available
    if (response.user.id.isNotEmpty) {
      await LocalStorageService.setUserId(response.user.id);
    }
  }

  // Reset all forgot password data
  void reset() {
    _resetEmail = '';
    _newPassword = '';
    _confirmPassword = '';
    _isRequestingReset = false;
    _isResetRequested = false;
    _resetRequestError = null;
    _resetRequestErrorCode = null;
    _resetCodeExpiresAt = null;
    _isConfirmingReset = false;
    _isResetConfirmed = false;
    _resetConfirmError = null;
    _resetConfirmErrorCode = null;
    _resetConfirmResponse = null;
    clearEmailCode();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

