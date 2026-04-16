import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'calendar_permission_service.dart';

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  /// Requests calendar permissions using both permission_handler and device_calendar.
  Future<bool> requestPermissions() async {
    // 1. Try with general permission_handler
    final handlerGranted = await CalendarPermissionService.requestCalendarPermission();
    
    // 2. Also try with device_calendar plugin's specific request
    final pluginResult = await _deviceCalendarPlugin.requestPermissions();
    final pluginGranted = pluginResult.isSuccess && pluginResult.data == true;

    return handlerGranted || pluginGranted;
  }

  /// Retrieves the default calendar ID for the device.
  /// Prefers primary/default calendars, then writable ones.
  Future<String?> getDefaultCalendarId() async {
    try {
      final permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        final requestPermissionsResult = await _deviceCalendarPlugin.requestPermissions();
        if (requestPermissionsResult.isSuccess && !requestPermissionsResult.data!) {
          return null;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        final calendars = calendarsResult.data!;
        if (calendars.isNotEmpty) {
          // Find the default calendar or the first writable one
          final defaultCalendar = calendars.firstWhere(
            (calendar) => calendar.isDefault ?? false,
            orElse: () => calendars.firstWhere(
              (calendar) => !(calendar.isReadOnly ?? true),
              orElse: () => calendars.first,
            ),
          );
          return defaultCalendar.id;
        }
      }
    } catch (e) {
      debugPrint('Error getting default calendar ID: $e');
    }
    return null;
  }

  /// Checks if an event with the same title and time range already exists.
  Future<bool> isEventAlreadyAdded({
    required String title,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final calendarId = await getDefaultCalendarId();
      if (calendarId == null) return false;

      // Search for events in a small window using literal values
      final startTime = tz.TZDateTime(tz.local, start.year, start.month, start.day, start.hour, start.minute);
      final endTime = tz.TZDateTime(tz.local, end.year, end.month, end.day, end.hour, end.minute);

      final parameters = RetrieveEventsParams(
        startDate: startTime.subtract(const Duration(minutes: 5)),
        endDate: endTime.add(const Duration(minutes: 5)),
      );

      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(calendarId, parameters);
      if (eventsResult.isSuccess && eventsResult.data != null) {
        final events = eventsResult.data!;
        // Check if any event has the same title
        return events.any((event) => event.title == title);
      }
    } catch (e) {
      debugPrint('Error checking for duplicate event: $e');
    }
    return false;
  }

  /// Creates an event in the device's default calendar.
  Future<bool> createEvent({
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
    List<int>? reminderMinutes,
  }) async {
    try {
      // 1. Check if already exists to prevent duplicates
      final exists = await isEventAlreadyAdded(title: title, start: start, end: end);
      if (exists) {
        debugPrint('Event already exists in calendar.');
        return true; // Return true as it's already "successfully" there
      }

      final calendarId = await getDefaultCalendarId();
      if (calendarId == null) {
        debugPrint('No writable calendar found or permission denied.');
        return false;
      }

      // Use the literal hour/minute values to avoid any automatic UTC/Local shifts
      // this ensures that if 'start' says 1:00 PM, the calendar event will be 1:00 PM
      final event = Event(
        calendarId,
        title: title,
        description: description,
        start: tz.TZDateTime(
          tz.local,
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute,
        ),
        end: tz.TZDateTime(
          tz.local,
          end.year,
          end.month,
          end.day,
          end.hour,
          end.minute,
        ),
      );

      if (reminderMinutes != null && reminderMinutes.isNotEmpty) {
        event.reminders = reminderMinutes.map((m) => Reminder(minutes: m)).toList();
      }

      final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
      return result?.isSuccess ?? false;
    } catch (e) {
      debugPrint('Error creating event: $e');
      return false;
    }
  }
}
