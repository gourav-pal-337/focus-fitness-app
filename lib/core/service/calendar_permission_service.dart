import 'package:permission_handler/permission_handler.dart';

class CalendarPermissionService {
  /// Requests calendar permission and returns true if granted.
  /// Handles denied and permanently denied states.
  static Future<bool> requestCalendarPermission() async {
    // Check current status for basic calendar permission
    PermissionStatus status = await Permission.calendar.status;
    
    if (status.isGranted) {
      return true;
    }
    
    // Request permission if not granted
    if (status.isDenied || status.isLimited) {
      status = await Permission.calendar.request();
      if (status.isGranted) return true;
    }
    
    // Fallback for iOS 17+ specific full access permission
    // In many cases, Permission.calendar is mapped to full access, 
    // but some versions of permission_handler differentiate them.
    PermissionStatus fullAccessStatus = await Permission.calendarFullAccess.status;
    if (fullAccessStatus.isDenied || fullAccessStatus.isLimited) {
      fullAccessStatus = await Permission.calendarFullAccess.request();
      if (fullAccessStatus.isGranted) return true;
    }

    // If still not granted and permanently denied, guide user to settings
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
