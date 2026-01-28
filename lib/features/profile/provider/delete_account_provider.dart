import 'package:flutter/material.dart';

import '../data/services/profile_api_service.dart';

class DeleteAccountProvider extends ChangeNotifier {
  final ProfileApiService _apiService = ProfileApiService();
  bool _showDeleteForm = false;
  String _reason = '';
  bool _isLoading = false;

  bool get showDeleteForm => _showDeleteForm;
  String get reason => _reason;
  bool get isLoading => _isLoading;

  void showForm() {
    _showDeleteForm = true;
    notifyListeners();
  }

  void updateReason(String value) {
    _reason = value;
    notifyListeners();
  }

  Future<bool> deleteAccount() async {
    if (_reason.isEmpty) {
      // Optional: enforce reason? User said "also add the deletion reason".
      // Assuming reason is required or at least sent.
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteAccount(reason: _reason);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting account: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
