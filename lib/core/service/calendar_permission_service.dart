import 'package:permission_handler/permission_handler.dart';

class CalendarPermissionService {
  /// Requests calendar permission and returns true if granted.
  /// Handles denied and permanently denied states.
  static Future<bool> requestCalendarPermission() async {
    // IMPORTANT: request FULL access first.
    // On iOS 17+, Permission.calendar can resolve to write-only ("Add Events
    // Only") access. With write-only access device_calendar cannot ENUMERATE
    // calendars, so no writable calendar id is ever found and event creation
    // fails. Full access is required to look up the default calendar.
    PermissionStatus fullAccessStatus =
        await Permission.calendarFullAccess.status;
    if (fullAccessStatus.isGranted) return true;
    if (fullAccessStatus.isDenied || fullAccessStatus.isLimited) {
      fullAccessStatus = await Permission.calendarFullAccess.request();
      if (fullAccessStatus.isGranted) return true;
    }

    // Fallback to the generic calendar permission (older iOS / Android, where
    // this maps to read+write calendar access).
    PermissionStatus status = await Permission.calendar.status;
    if (status.isGranted) return true;
    if (status.isDenied || status.isLimited) {
      status = await Permission.calendar.request();
      if (status.isGranted) return true;
    }

    // If permanently denied, guide the user to app settings.
    if (status.isPermanentlyDenied || fullAccessStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  /// Checks if calendar permission is currently granted.
  static Future<bool> checkPermission() async {
    return await Permission.calendar.isGranted || await Permission.calendarFullAccess.isGranted;
  }
}
