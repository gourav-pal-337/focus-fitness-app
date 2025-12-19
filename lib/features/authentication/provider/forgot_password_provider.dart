import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
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

  // Reset all forgot password data
  void reset() {
    _resetEmail = '';
    _newPassword = '';
    _confirmPassword = '';
    clearEmailCode();
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

