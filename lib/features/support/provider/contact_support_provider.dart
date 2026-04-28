import 'dart:io';

import 'package:flutter/foundation.dart';
import '../../../../features/support/data/repositories/support_repository.dart';
import '../data/models/ticket_model.dart';

class ContactSupportProvider extends ChangeNotifier {
  final SupportRepository _repository = SupportRepository();
  bool _isLoading = false;
  String? _error;

  String _issueType = '';
  String _severity = '';
  String _subject = '';
  String _description = '';
  String? _screenshotPath;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get issueType => _issueType;
  String get severity => _severity;
  String get subject => _subject;
  String get description => _description;
  String? get screenshotPath => _screenshotPath;

  void updateIssueType(String value) {
    _issueType = value;
    notifyListeners();
  }

  void updateSeverity(String value) {
    _severity = value;
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

  Future<TicketModel?> submitTicket() async {
    _error = null;
    if (_issueType.isEmpty) {
      _error = 'Please select an issue type';
      notifyListeners();
      return null;
    }
    if (_severity.isEmpty) {
      _error = 'Please select severity';
      notifyListeners();
      return null;
    }
    if (_description.isEmpty) {
      _error = 'Please enter a description';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      File? file;
      if (_screenshotPath != null && _screenshotPath!.isNotEmpty) {
        file = File(_screenshotPath!);
      }

      // Map severity to priority
      String priority = 'low';
      if (_severity.contains('Critical')) {
        priority = 'high';
      } else if (_severity.contains('Medium')) {
        priority = 'medium';
      }

      debugPrint("category : $_issueType");
      debugPrint("priority : $priority");
      debugPrint("description : $_description");
      debugPrint("title : $_severity");
      // return null;
      final ticket = await _repository.createTicket(
        title: _severity,
        description: _description,
        category: _issueType,
        priority: priority,
        file: file,
      );

      debugPrint('ticket 11: $ticket');

      _isLoading = false;
      notifyListeners();
      return ticket;
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
