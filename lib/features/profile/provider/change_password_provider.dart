import 'package:flutter/material.dart';

class ChangePasswordProvider extends ChangeNotifier {
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  String get oldPassword => _oldPassword;
  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;

  void updateOldPassword(String value) {
    _oldPassword = value;
    notifyListeners();
  }

  void updateNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void save() {
    // TODO: Implement save logic (API call, validation, etc.)
    // For now, just notify that save was called
  }
}

