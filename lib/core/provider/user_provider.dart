import 'package:flutter/foundation.dart';

import '../../features/authentication/data/models/register_response_model.dart';
import '../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;
import '../../features/user/data/repository/user_repository.dart';

/// Global user provider to access user information throughout the app
class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  final UserRepository _userRepository = UserRepository();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// Fetch current user details from API
  Future<bool> fetchUserDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _userRepository.getUserDetails();

      return await result.when(
        success: (response) async {
          _user = response.user;
          _isLoading = false;
          _error = null;
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
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set user data
  void setUser(UserModel? user) {
    _user = user;
    _error = null;
    notifyListeners();
  }

  /// Clear user data
  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    if (!loading) {
      notifyListeners();
    }
  }

  /// Set error state
  void setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Update user data
  void updateUser(UserModel user) {
    _user = user;
    _error = null;
    notifyListeners();
  }
}

