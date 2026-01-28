import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/service/local_storage_service.dart';
import '../../trainer/data/models/link_trainer_request_model.dart';
import '../../trainer/data/models/link_trainer_response_model.dart';
import '../../trainer/data/models/trainer_referral_response_model.dart';
import '../../trainer/data/repository/trainer_repository.dart';
import '../data/models/login_request_model.dart';
import '../data/models/login_response_model.dart';
import '../data/models/register_request_model.dart';
import '../data/models/register_response_model.dart';
import '../data/repository/auth_repository.dart';

/// UI state for authentication operations
enum AuthState { idle, loading, loginSuccess, registerSuccess, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final TrainerRepository _trainerRepository = TrainerRepository();

  // Existing form state
  String _name = '';
  String get name => _name;
  bool get canProceedWithName => _name.trim().isNotEmpty;

  void updateName(String value) {
    _name = value;
    notifyListeners();
  }

  // Phone Number Entry
  String _countryCode = '+91';
  String _phoneNumber = '';

  String get countryCode => _countryCode;
  String get phoneNumber => _phoneNumber;
  bool get canProceedWithPhone => _phoneNumber.trim().isNotEmpty;

  void updateCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  // OTP Verification
  String _otp = '';

  String get otp => _otp;
  bool get canProceedWithOtp => _otp.length == 4;

  void updateOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  void clearOtp() {
    _otp = '';
    notifyListeners();
  }

  // Trainer ID Entry
  String _trainerId = '';
  String get trainerId => _trainerId;
  bool get canProceedWithTrainerId => _trainerId.trim().isNotEmpty;

  // Trainer lookup state
  bool _isValidatingTrainer = false;
  List<TrainerInfo> _foundTrainers = [];
  TrainerInfo? _selectedTrainer;
  String? _trainerValidationError;

  bool get isValidatingTrainer => _isValidatingTrainer;
  List<TrainerInfo> get foundTrainers => _foundTrainers;
  TrainerInfo? get foundTrainer =>
      _selectedTrainer; // For backward compatibility
  TrainerInfo? get selectedTrainer => _selectedTrainer;
  String? get trainerValidationError => _trainerValidationError;
  bool get isTrainerValid =>
      _selectedTrainer != null && _trainerValidationError == null;
  bool get hasTrainers => _foundTrainers.isNotEmpty;

  void updateTrainerId(String value) {
    _trainerId = value;
    // Clear previous validation results when user types
    _foundTrainers = [];
    _selectedTrainer = null;
    _trainerValidationError = null;
    notifyListeners();
  }

  /// Select a trainer from the search results
  void selectTrainer(TrainerInfo trainer) {
    _selectedTrainer = trainer;
    _trainerId = trainer.referralCode;
    notifyListeners();
  }

  /// Search trainer by referral code (new API with enhanced details)
  /// Requires authentication
  /// Returns list of trainers matching the search
  Future<void> searchTrainer(String referralCode) async {
    if (referralCode.trim().isEmpty) {
      _foundTrainers = [];
      _selectedTrainer = null;
      _trainerValidationError = null;
      _isValidatingTrainer = false;
      notifyListeners();
      return;
    }

    _isValidatingTrainer = true;
    _trainerValidationError = null;
    _foundTrainers = [];
    _selectedTrainer = null;
    notifyListeners();

    try {
      final result = await _trainerRepository.searchTrainerByReferralCode(
        referralCode,
      );

      await result.when(
        success: (response) async {
          _foundTrainers = response.trainers;
          // Auto-select if only one trainer found
          if (response.trainers.length == 1) {
            _selectedTrainer = response.trainers.first;
            _trainerId = _selectedTrainer!.referralCode;
          } else {
            _selectedTrainer = null;
          }
          _trainerValidationError = null;
          _isValidatingTrainer = false;
          notifyListeners();
        },
        failure: (message, code) {
          _foundTrainers = [];
          _selectedTrainer = null;
          _trainerValidationError = message;
          _isValidatingTrainer = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _foundTrainers = [];
      _selectedTrainer = null;
      _trainerValidationError = e.toString().replaceAll('Exception: ', '');
      _isValidatingTrainer = false;
      notifyListeners();
    }
  }

  /// Validate trainer referral code (deprecated - use searchTrainer instead)
  @Deprecated('Use searchTrainer instead')
  Future<void> validateTrainerCode(String referralCode) async {
    return searchTrainer(referralCode);
  }

  /// Clear trainer validation state
  void clearTrainerValidation() {
    _foundTrainers = [];
    _selectedTrainer = null;
    _trainerValidationError = null;
    _isValidatingTrainer = false;
    notifyListeners();
  }

  // Trainer Linking state
  bool _isLinkingTrainer = false;
  bool _isTrainerLinked = false;
  LinkTrainerResponseModel? _linkTrainerResponse;
  String? _linkTrainerError;
  int? _linkTrainerErrorCode;

  bool get isLinkingTrainer => _isLinkingTrainer;
  bool get isTrainerLinked => _isTrainerLinked;
  LinkTrainerResponseModel? get linkTrainerResponse => _linkTrainerResponse;
  String? get linkTrainerError => _linkTrainerError;
  int? get linkTrainerErrorCode => _linkTrainerErrorCode;

  /// Link trainer with referral code
  Future<bool> linkTrainer({
    String? fullName,
    String? preferredName,
    String? email,
    String? phone,
    String? goals,
    String? healthNotes,
    String? notes,
  }) async {
    if (_trainerId.trim().isEmpty) {
      _linkTrainerError = 'Trainer ID is required.';
      _linkTrainerErrorCode = 400;
      notifyListeners();
      return false;
    }

    _isLinkingTrainer = true;
    _linkTrainerError = null;
    _linkTrainerErrorCode = null;
    notifyListeners();

    try {
      // Use provided fullName or fallback to name from AuthProvider
      final clientFullName = fullName?.trim() ?? _name.trim();
      if (clientFullName.isEmpty) {
        _isLinkingTrainer = false;
        _linkTrainerError = 'Full name is required.';
        _linkTrainerErrorCode = 400;
        notifyListeners();
        return false;
      }

      final request = LinkTrainerRequestModel(
        referralCode: _trainerId.trim(),
        fullName: clientFullName,
        preferredName: preferredName,
        email: email,
        phone: phone,
        goals: goals,
        healthNotes: healthNotes,
        notes: notes,
      );

      final result = await _trainerRepository.linkTrainer(request);

      return await result.when(
        success: (response) async {
          _linkTrainerResponse = response;
          _isTrainerLinked = true;
          _isLinkingTrainer = false;
          _linkTrainerError = null;
          _linkTrainerErrorCode = null;
          notifyListeners();
          return true;
        },
        failure: (message, code) {
          _linkTrainerError = message;
          _linkTrainerErrorCode = code;
          _isLinkingTrainer = false;
          _isTrainerLinked = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _linkTrainerError = e.toString().replaceAll('Exception: ', '');
      _linkTrainerErrorCode = 500;
      _isLinkingTrainer = false;
      _isTrainerLinked = false;
      notifyListeners();
      return false;
    }
  }

  void resetTrainerLink() {
    _isTrainerLinked = false;
    _linkTrainerResponse = null;
    _linkTrainerError = null;
    _linkTrainerErrorCode = null;
    notifyListeners();
  }

  // Forgot Password
  String _resetEmail = '';
  String get resetEmail => _resetEmail;
  bool get canProceedWithResetEmail {
    final email = _resetEmail.trim();
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  void updateResetEmail(String value) {
    _resetEmail = value;
    notifyListeners();
  }

  // Email Verification Code
  final List<TextEditingController> _emailCodeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  List<TextEditingController> get emailCodeControllers => _emailCodeControllers;

  String get emailCode => _emailCodeControllers.map((c) => c.text).join();
  bool get canProceedWithEmailCode => emailCode.length == 4;

  void updateEmailCode(int index, String value) {
    if (value.length > 1) {
      _emailCodeControllers[index].text = value[value.length - 1];
    } else {
      _emailCodeControllers[index].text = value;
    }
    notifyListeners();
  }

  void clearEmailCode() {
    for (var controller in _emailCodeControllers) {
      controller.clear();
    }
    notifyListeners();
  }

  // Login/Register state
  AuthState _authState = AuthState.idle;
  LoginResponseModel? _loginResponse;
  RegisterResponseModel? _registerResponse;
  String _errorMessage = '';
  int? _errorCode;

  AuthState get authState => _authState;
  LoginResponseModel? get loginResponse => _loginResponse;
  RegisterResponseModel? get registerResponse => _registerResponse;
  String get errorMessage => _errorMessage;
  int? get errorCode => _errorCode;

  bool get isLoading => _authState == AuthState.loading;
  bool get isLoginSuccess => _authState == AuthState.loginSuccess;
  bool get isRegisterSuccess => _authState == AuthState.registerSuccess;
  bool get isError => _authState == AuthState.error;
  bool get isIdle => _authState == AuthState.idle;

  bool get emailVerificationRequired =>
      _loginResponse?.emailVerificationRequired ?? false;

  /// Login user with email and password
  Future<void> loginWithEmail(LoginRequestModel request) async {
    _setAuthState(AuthState.loading);
    _errorMessage = '';
    _errorCode = null;

    try {
      final result = await _repository.loginWithEmail(request);

      await result.when(
        success: (response) async {
          _loginResponse = response;

          // Store tokens in secure storage
          await _storeLoginTokens(response);

          _setAuthState(AuthState.loginSuccess);
        },
        failure: (message, code) {
          _errorMessage = message;
          _errorCode = code;
          _setAuthState(AuthState.error);
        },
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _errorCode = 500;
      _setAuthState(AuthState.error);
    }
  }

  /// Register user with email and password
  Future<void> registerWithEmail(RegisterRequestModel request) async {
    _setAuthState(AuthState.loading);
    _errorMessage = '';
    _errorCode = null;

    try {
      final result = await _repository.registerWithEmail(request);

      await result.when(
        success: (response) async {
          _registerResponse = response;

          // Store tokens in secure storage
          await _storeRegisterTokens(response);

          _setAuthState(AuthState.registerSuccess);
        },
        failure: (message, code) {
          _errorMessage = message;
          _errorCode = code;
          _setAuthState(AuthState.error);
        },
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _errorCode = 500;
      _setAuthState(AuthState.error);
    }
  }

  /// Store authentication tokens from login response
  Future<void> _storeLoginTokens(LoginResponseModel response) async {
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
    if (response.user?.id != null) {
      await LocalStorageService.setUserId(response.user!.id);
    }
  }

  /// Store authentication tokens from register response
  Future<void> _storeRegisterTokens(RegisterResponseModel response) async {
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
    if (response.user?.id != null) {
      await LocalStorageService.setUserId(response.user!.id);
    }
  }

  void _setAuthState(AuthState newState) {
    _authState = newState;
    notifyListeners();
  }

  /// Reset auth state to idle
  void resetAuthState() {
    _authState = AuthState.idle;
    _loginResponse = null;
    _registerResponse = null;
    _errorMessage = '';
    _errorCode = null;
    notifyListeners();
  }

  // Reset all auth data
  void reset() {
    _name = '';
    _countryCode = '+91';
    _phoneNumber = '';
    _trainerId = '';
    _resetEmail = '';
    resetTrainerLink();
    clearTrainerValidation();
    clearOtp();
    clearEmailCode();
    resetAuthState();
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in _emailCodeControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
