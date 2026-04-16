import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/update_client_profile_request_model.dart';
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
      debugPrint("profile result ${result.toString()}");
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

  /// Update profile manually
  void updateProfile(ClientProfileModel profile) {
    _profile = profile;
    notifyListeners();
  }

  /// Clear profile data
  void clear() {
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Update profile photo
  Future<bool> updateProfilePhoto(XFile file) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Upload the photo
      final uploadResult = await _repository.uploadProfilePhoto(file);

      return await uploadResult.when(
        success: (photoUrl) async {
          // 2. Update the profile with the new photo URL
          final updateResult = await _repository.updateClientProfile(
            UpdateClientProfileRequestModel(profilePicture: photoUrl),
          );

          return await updateResult.when(
            success: (response) async {
              // 3. Refresh profile
              await fetchProfile();
              _isLoading = false;
              notifyListeners();
              return true;
            },
            failure: (message, code) {
              _error = message;
              _isLoading = false;
              notifyListeners();
              return false;
            },
          );
        },
        failure: (message, code) {
          _error = message;
          _isLoading = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
