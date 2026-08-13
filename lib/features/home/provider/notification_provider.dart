import 'package:flutter/foundation.dart';

import '../../../core/service/local_storage_service.dart';
import '../data/models/notification_model.dart';
import '../data/repository/home_repository.dart';

/// Manages the notification list and per-user read/unread state.
///
/// The backend does not track a per-user "read" flag, so read state is kept
/// locally (persisted via [LocalStorageService]). A notification is considered
/// unread whenever its id is not in the locally stored read-id set.
class NotificationProvider extends ChangeNotifier {
  NotificationProvider({HomeRepository? repository})
    : _repository = repository ?? HomeRepository();

  final HomeRepository _repository;

  List<NotificationModel> _notifications = [];
  Set<String> _readIds = {};
  bool _isLoading = false;
  bool _hasError = false;
  bool _readIdsLoaded = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// Number of notifications the user hasn't read yet.
  int get unreadCount =>
      _notifications.where((n) => !_readIds.contains(n.id)).length;

  bool isRead(NotificationModel n) => _readIds.contains(n.id);

  Future<void> _ensureReadIdsLoaded() async {
    if (_readIdsLoaded) return;
    _readIds = await LocalStorageService.getReadNotificationIds();
    _readIdsLoaded = true;
  }

  /// Fetch notifications from the API and refresh the badge count.
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await _ensureReadIdsLoaded();
      _notifications = await _repository.getNotifications();

      // Drop read ids that no longer correspond to any notification so the
      // stored set doesn't grow forever.
      final liveIds = _notifications.map((n) => n.id).toSet();
      final prunedReadIds = _readIds.intersection(liveIds);
      if (prunedReadIds.length != _readIds.length) {
        _readIds = prunedReadIds;
        await LocalStorageService.setReadNotificationIds(_readIds);
      }
    } catch (e) {
      debugPrint('NotificationProvider: fetch failed: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String id) async {
    if (id.isEmpty || _readIds.contains(id)) return;
    await _ensureReadIdsLoaded();
    _readIds = {..._readIds, id};
    notifyListeners();
    await LocalStorageService.setReadNotificationIds(_readIds);
  }

  /// Mark every currently loaded notification as read.
  Future<void> markAllAsRead() async {
    await _ensureReadIdsLoaded();
    final allIds = _notifications.map((n) => n.id).where((e) => e.isNotEmpty);
    final updated = {..._readIds, ...allIds};
    if (updated.length == _readIds.length) return;
    _readIds = updated;
    notifyListeners();
    await LocalStorageService.setReadNotificationIds(_readIds);
  }
}
