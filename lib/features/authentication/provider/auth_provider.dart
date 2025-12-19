import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // Name Entry
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
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  List<TextEditingController> get otpControllers => _otpControllers;
  
  String get otp => _otpControllers.map((c) => c.text).join();
  bool get canProceedWithOtp => otp.length == 4;

  void updateOtp(int index, String value) {
    if (value.length > 1) {
      _otpControllers[index].text = value[value.length - 1];
    } else {
      _otpControllers[index].text = value;
    }
    notifyListeners();
  }

  void clearOtp() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    notifyListeners();
  }

  // Trainer ID Entry
  String _trainerId = '';
  String get trainerId => _trainerId;
  bool get canProceedWithTrainerId => _trainerId.trim().isNotEmpty;

  void updateTrainerId(String value) {
    _trainerId = value;
    notifyListeners();
  }

  // Trainer Linking
  bool _isTrainerLinked = false;
  bool get isTrainerLinked => _isTrainerLinked;

  void linkTrainer() {
    _isTrainerLinked = true;
    notifyListeners();
  }

  void resetTrainerLink() {
    _isTrainerLinked = false;
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

  // Reset all auth data
  void reset() {
    _name = '';
    _countryCode = '+91';
    _phoneNumber = '';
    _trainerId = '';
    _resetEmail = '';
    _isTrainerLinked = false;
    clearOtp();
    clearEmailCode();
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var controller in _emailCodeControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

