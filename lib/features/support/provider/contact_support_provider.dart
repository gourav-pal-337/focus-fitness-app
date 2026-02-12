import 'dart:io';

import 'package:flutter/foundation.dart';
import '../../../../features/support/data/repositories/support_repository.dart';

class ContactSupportProvider extends ChangeNotifier {
  final SupportRepository _repository = SupportRepository();
  bool _isLoading = false;
  String? _error;

  String _issueType = '';
  String _subject = '';
  String _description = '';
  String? _screenshotPath;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get issueType => _issueType;
  String get subject => _subject;
  String get description => _description;
  String? get screenshotPath => _screenshotPath;

  void updateIssueType(String value) {
    _issueType = value;
    notifyListeners();
  }

  void updateSubject(String value) {
    _subject = value;
    notifyListeners();
  }

  void updateDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void updateScreenshotPath(String? path) {
    _screenshotPath = path;
    notifyListeners();
  }

  Future<bool> submitTicket() async {
    _error = null;
    if (_issueType.isEmpty) {
      _error = 'Please select an issue type';
      notifyListeners();
      return false;
    }
    if (_subject.isEmpty) {
      _error = 'Please enter a subject';
      notifyListeners();
      return false;
    }
    if (_description.isEmpty) {
      _error = 'Please enter a description';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      File? file;
      if (_screenshotPath != null && _screenshotPath!.isNotEmpty) {
        file = File(_screenshotPath!);
      }

      await _repository.createTicket(
        title: _subject,
        description: _description,
        category: _issueType,
        priority:
            'medium', // Default priority, can be enhanced if UI supports it
        file: file,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
