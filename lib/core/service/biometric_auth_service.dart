import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Service for handling biometric authentication
class BiometricAuthService {
  static final BiometricAuthService _instance = BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();
  bool? _isDeviceSupported;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;

  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    if (_isDeviceSupported != null) {
      return _isDeviceSupported!;
    }
    try {
      _isDeviceSupported = await _auth.isDeviceSupported();
      return _isDeviceSupported!;
    } catch (e) {
      log('Error checking device support: $e');
      _isDeviceSupported = false;
      return false;
    }
  }

  /// Check if biometrics can be checked
  Future<bool> canCheckBiometrics() async {
    if (_canCheckBiometrics != null) {
      return _canCheckBiometrics!;
    }
    try {
      _canCheckBiometrics = await _auth.canCheckBiometrics;
      return _canCheckBiometrics!;
    } on PlatformException catch (e) {
      log('Error checking biometrics: $e');
      _canCheckBiometrics = false;
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (_availableBiometrics != null) {
      return _availableBiometrics!;
    }
    try {
      _availableBiometrics = await _auth.getAvailableBiometrics();
      return _availableBiometrics!;
    } on PlatformException catch (e) {
      log('Error getting available biometrics: $e');
      _availableBiometrics = <BiometricType>[];
      return [];
    }
  }

  /// Authenticate using biometrics
  /// Returns true if authentication is successful, false otherwise
  /// Set biometricOnly to false to allow passcode fallback on iOS
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to continue',
    bool biometricOnly = false,
  }) async {
    try {
      // Check if device is supported
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        log('Device does not support biometric authentication');
        return false;
      }

      // Check if biometrics can be checked
      final canCheck = await canCheckBiometrics();
      if (!canCheck) {
        log('Cannot check biometrics');
        return false;
      }

      // Perform authentication
      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        persistAcrossBackgrounding: true,
        biometricOnly: biometricOnly,
      );

      return authenticated;
    } on LocalAuthException catch (e) {
      log('LocalAuthException: ${e.code}');
      // Handle specific error codes
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled) {
        // User canceled, return false but don't log as error
        return false;
      }
      return false;
    } on PlatformException catch (e) {
      log('PlatformException during authentication: ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error during authentication: $e');
      return false;
    }
  }

  /// Stop ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      log('Error stopping authentication: $e');
    }
  }

  /// Reset cached values (useful for testing or when device state changes)
  void resetCache() {
    _isDeviceSupported = null;
    _canCheckBiometrics = null;
    _availableBiometrics = null;
  }
}

