import 'package:flutter/material.dart';

import '../../../core/service/local_storage_service.dart';

class TwoFactorAuthProvider extends ChangeNotifier {
  bool _isEnabled = false;
  bool _isLoading = false;

  bool get isEnabled => _isEnabled;
  bool get isLoading => _isLoading;

  /// Initialize provider by loading saved state from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isEnabled = await LocalStorageService.getTwoFactorAuthEnabled();
    } catch (e) {
      // If error occurs, default to false
      _isEnabled = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle two-factor authentication status
  Future<void> toggle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newValue = !_isEnabled;
      final success = await LocalStorageService.setTwoFactorAuthEnabled(newValue);
      
      if (success) {
        _isEnabled = newValue;
        // TODO: Implement API call to update two-factor authentication status on server
      } else {
        // If save failed, revert the change
        // Error is already logged in LocalStorageService
      }
    } catch (e) {
      // Error occurred, state remains unchanged
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

