import 'package:flutter/material.dart';

class DeleteAccountProvider extends ChangeNotifier {
  bool _showDeleteForm = false;
  String _reason = '';

  bool get showDeleteForm => _showDeleteForm;
  String get reason => _reason;

  void showForm() {
    _showDeleteForm = true;
    notifyListeners();
  }

  void updateReason(String value) {
    _reason = value;
    notifyListeners();
  }

  void deleteAccount() {
    // TODO: Implement delete account API call
  }
}

