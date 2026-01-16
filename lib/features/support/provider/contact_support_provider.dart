import 'package:flutter/foundation.dart';

class ContactSupportProvider extends ChangeNotifier {
  String _issueType = '';
  String _subject = '';
  String _description = '';
  String? _screenshotPath;

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

  void submitTicket() {
    // TODO: Implement ticket submission logic
    if (kDebugMode) {
      print('Submitting ticket:');
      print('Issue Type: $_issueType');
      print('Subject: $_subject');
      print('Description: $_description');
      print('Screenshot: $_screenshotPath');
    }
  }
}


