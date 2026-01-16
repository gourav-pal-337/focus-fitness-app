import 'package:flutter/foundation.dart';

import '../data/models/client_profile_model.dart';
import '../data/repository/profile_repository.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

/// Provider to manage client profile state
class ClientProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  bool _isLoading = false;
  ClientProfileModel? _profile;
  String? _error;

  bool get isLoading => _isLoading;
  ClientProfileModel? get profile => _profile;
  String? get error => _error;

  /// Fetch client profile
  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getClientProfile();

      await result.when(
        success: (response) async {
          _profile = response.profile;
          _error = null;
          _isLoading = false;
          notifyListeners();
        },
        failure: (message, code) {
          _profile = null;
          _error = message;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _profile = null;
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await fetchProfile();
  }

  /// Clear profile data
  void clear() {
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

