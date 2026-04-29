import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class TimeUtils {
  /// 1. Detect user timezone using device
  static Future<String> getUserTimezone() async {
    try {
      final dynamic result = await FlutterTimezone.getLocalTimezone();
      if (result is String) return result;
      // Some versions return a TimezoneInfo object, we extract the name
      return result
          .toString()
          .split('(')
          .last
          .split(',')
          .first
          .replaceAll(')', '')
          .trim();
    } catch (e) {
      return 'UTC';
    }
  }

  /// 2. Convert UTC ISO string from backend to local time for display
  /// Returns: "2:00 PM - 2:30 PM (Your Time)" or similar
  static String formatToLocalTimeRange(
    String? startUtc,
    String? endUtc, {
    bool showfulltime = true,
  }) {
    if (startUtc == null || endUtc == null) return '--';

    try {
      final start = DateTime.parse(startUtc).toLocal();
      final end = DateTime.parse(endUtc).toLocal();

      final timeFormat = DateFormat('h:mm a');
      final startStr = timeFormat.format(start).toLowerCase();
      final endStr = timeFormat.format(end).toLowerCase();

      return "${startStr.toString().toUpperCase()} ${showfulltime ? ' - ' : ''}${showfulltime ? endStr.toString().toUpperCase() : ''}";
      // - $endStr (Your Time)';
    } catch (e) {
      return '--';
    }
  }

  /// 3. Convert single UTC ISO string to local time string
  static String formatToLocalTime(
    String? utcIsoString, {
    String format = 'h:mm a',
  }) {
    if (utcIsoString == null || utcIsoString.isEmpty) return '--';

    try {
      DateTime localDate = DateTime.parse(utcIsoString).toLocal();
      return DateFormat(format).format(localDate).toLowerCase();
    } catch (e) {
      return utcIsoString;
    }
  }

  /// 4. Convert single UTC ISO string to local date string
  static String formatToLocalDate(
    String? utcIsoString, {
    String format = 'dd MMM yyyy',
  }) {
    if (utcIsoString == null || utcIsoString.isEmpty) return '--';

    try {
      DateTime localDate = DateTime.parse(utcIsoString).toLocal();
      return DateFormat(format).format(localDate);
    } catch (e) {
      return utcIsoString;
    }
  }

  /// 5. Format DateTime to "naive" ISO string (no 'Z') for backend
  /// This represents the local wall-clock time
  static String formatToBackend(DateTime localDateTime) {
    // Returns YYYY-MM-DDTHH:mm:ss.sss (no Z)
    return localDateTime.toIso8601String().split('Z')[0].split('+')[0];
  }

  /// 6. Combine Date and Time into a proper DateTime object
  static DateTime combineDateAndTime(DateTime date, String timeSlot) {
    // timeSlot format: "3:09 pm" or "15:09"
    final timeParts = _parseTimeSlot(timeSlot);
    return DateTime(
      date.year,
      date.month,
      date.day,
      timeParts.hour,
      timeParts.minute,
    );
  }

  /// Helper to parse "3:09 pm" into hour and minute
  static DateTime _parseTimeSlot(String timeSlot) {
    final format = DateFormat('h:mm a');
    try {
      return format.parse(timeSlot.toUpperCase());
    } catch (e) {
      // Fallback for 24h format if needed
      final parts = timeSlot.split(':');
      if (parts.length == 2) {
        return DateTime(2024, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      }
      return DateTime(2024, 1, 1, 0, 0);
    }
  }
}
