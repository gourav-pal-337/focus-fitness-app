import 'package:flutter/material.dart';

import '../../../core/service/local_storage_service.dart';
import '../../authentication/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/user_provider.dart';
import '../data/models/update_client_profile_request_model.dart';
import '../data/services/profile_api_service.dart';

enum TfaViewState { initial, enteringPhone, enteringOtp, success }

class TwoFactorAuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isEnabled = false;
  bool _isLoading = false;
  String _errorMessage = '';

  TfaViewState _viewState = TfaViewState.initial;
  String _phoneNumber = '';
  String _countryCode = '+44';
  String _countryFlag = '🇬🇧';

  bool get isEnabled => _isEnabled;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  TfaViewState get viewState => _viewState;
  String get phoneNumber => _phoneNumber;
  String get countryCode => _countryCode;
  String get countryFlag => _countryFlag;

  void updatePhone(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void updateCountry(String code, String flag) {
    _countryCode = code;
    _countryFlag = flag;
    notifyListeners();
  }

  void setViewState(TfaViewState state) {
    _viewState = state;
    _errorMessage = '';
    notifyListeners();
  }

  /// Initialize provider by loading saved state from storage
  Future<void> initialize(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      _isEnabled = user?.isTfaEnabled ?? false;
      if (user?.phone != null && user!.phone!.isNotEmpty) {
        _phoneNumber = user.phone!;
      }
      if (user?.phoneCountry != null && user!.phoneCountry!.isNotEmpty) {
        _countryCode = user.phoneCountry!;
      }
    } catch (e) {
      _isEnabled = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send TFA OTP to the provided phone number
  Future<bool> sendOtp() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final userId = await LocalStorageService.getUserId();
      if (userId == null) {
        _errorMessage = 'User not found. Please log in again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final fullPhone = '$_countryCode$_phoneNumber';
      final result = await _repository.sendTfaOtp(
        userId,
        fullPhone,
        _countryCode,
      );

      return result.when(
        success: (success) async {
          _viewState = TfaViewState.enteringOtp;
          _isLoading = false;
          notifyListeners();
          return true;
        },
        failure: (message, code) {
          _errorMessage = message;
          _isLoading = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Verify TFA OTP and enable/disable TFA
  Future<bool> verifyOtp(BuildContext context, String otp) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final userId = await LocalStorageService.getUserId();
      if (userId == null) {
        _errorMessage = 'User not found. Please log in again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final result = await _repository.verifyTfaOtp(
        userId,
        _phoneNumber,
        _countryCode,
        otp,
      );

      return result.when(
        success: (response) async {
          final request = UpdateClientProfileRequestModel(
            isTfaEnabled: true,
            tfaVerified: true,
          );
          await ProfileApiService().updateClientProfile(request);

          _isEnabled = true;
          _viewState = TfaViewState.success;
          _isLoading = false;
          notifyListeners();
          if (context.mounted) {
            await Provider.of<UserProvider>(
              context,
              listen: false,
            ).fetchUserDetails();
          }
          return true;
        },
        failure: (message, code) {
          _errorMessage = message;
          _isLoading = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle TFA status (called from switch)
  Future<void> toggle(BuildContext context) async {
    if (!_isEnabled) {
      // If turning ON, move to phone input state
      setViewState(TfaViewState.enteringPhone);
    } else {
      // If turning OFF, we might need verification too,
      // but for now let's just turn it off or implement the same flow
      _isLoading = true;
      notifyListeners();
      try {
        final result = await _repository.disableTfa();

        await result.when(
          success: (response) async {
            _isEnabled = false;
            if (context.mounted) {
              await Provider.of<UserProvider>(
                context,
                listen: false,
              ).fetchUserDetails();
            }
          },
          failure: (message, code) {
            _errorMessage = message;
          },
        );
      } catch (e) {
        _errorMessage = 'Failed to disable TFA';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
