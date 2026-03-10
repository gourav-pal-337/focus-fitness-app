import 'package:flutter/foundation.dart';
import '../../authentication/data/repository/auth_repository.dart';
import '../data/models/system_settings_model.dart';
import '../data/repository/system_settings_repository.dart';

class SystemSettingsProvider extends ChangeNotifier {
  final SystemSettingsRepository _repository = SystemSettingsRepository();

  bool _isLoading = false;
  FeeSettingsModel? _feeSettings;
  List<SystemSettingModel> _allSettings = [];
  String? _error;

  bool get isLoading => _isLoading;
  FeeSettingsModel? get feeSettings => _feeSettings;
  List<SystemSettingModel> get allSettings => _allSettings;
  String? get error => _error;

  /// Fetch current fee settings
  Future<void> fetchFeeSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getFeeSettings();

    await result.when(
      success: (settings) async {
        _feeSettings = settings;
        _isLoading = false;
        notifyListeners();
      },
      failure: (message, code) {
        _error = message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Fetch all system settings (Admin)
  Future<void> fetchAllSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getAllSettings();

    await result.when(
      success: (settings) async {
        _allSettings = settings;
        _isLoading = false;
        notifyListeners();
      },
      failure: (message, code) {
        _error = message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Update a setting (Admin)
  Future<bool> updateSetting(SystemSettingModel setting) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.updateSetting(setting);

    bool success = false;
    await result.when(
      success: (val) async {
        success = val;
        if (success) {
          // Refresh settings after update
          await fetchAllSettings();
        }
      },
      failure: (message, code) {
        _error = message;
        success = false;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Calculate total charged amount including platform fee and VAT
  double calculateTotalAmount(double sessionPrice) {
    if (_feeSettings == null) return sessionPrice;

    final serviceFee = _feeSettings!.platformFeeType == 'fixed'
        ? _feeSettings!.platformFee
        : (sessionPrice * (_feeSettings!.platformFee / 100));

    final vat = sessionPrice * (_feeSettings!.vatTaxPercent / 100);

    return sessionPrice + serviceFee + vat;
  }
}
