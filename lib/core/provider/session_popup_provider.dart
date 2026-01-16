import 'package:flutter/foundation.dart';

/// Global provider to manage session popup visibility
class SessionPopupProvider extends ChangeNotifier {
  bool _shouldShowPopup = false;
  bool _isBottomSheetShowing = false;
  SessionPopupData? _popupData;

  bool get shouldShowPopup => _shouldShowPopup;
  bool get isBottomSheetShowing => _isBottomSheetShowing;
  SessionPopupData? get popupData => _popupData;

  /// Show the session popup with the given data
  void showPopup(SessionPopupData data) {
    if (_isBottomSheetShowing) return; // Prevent showing multiple times
    _popupData = data;
    _shouldShowPopup = true;
    notifyListeners();
  }

  /// Mark bottom sheet as showing
  void setBottomSheetShowing(bool value) {
    _isBottomSheetShowing = value;
    notifyListeners();
  }

  /// Hide the session popup
  void hidePopup() {
    _shouldShowPopup = false;
    _isBottomSheetShowing = false;
    _popupData = null;
    notifyListeners();
  }

  /// Schedule popup to show after delay
  void schedulePopup(SessionPopupData data, {Duration delay = const Duration(seconds: 2)}) {
    Future.delayed(delay, () {
      showPopup(data);
    });
  }
}

/// Data model for session popup
class SessionPopupData {
  const SessionPopupData({
    required this.trainerName,
    required this.trainerImageUrl,
    required this.sessionDate,
    required this.sessionTime,
    this.onJoinSession,
    this.onDismiss,
  });

  final String trainerName;
  final String? trainerImageUrl;
  final String sessionDate;
  final String sessionTime;
  final VoidCallback? onJoinSession;
  final VoidCallback? onDismiss;
}

