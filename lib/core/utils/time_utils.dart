import 'package:intl/intl.dart';

class TimeUtils {
  // 1. Receives UTC ISO from Backend -> Converts to Local Device Time -> Formats
  static String formatToLocal(String? utcIsoString, {String format = 'dd MMM yyyy, h:mm a'}) {
    if (utcIsoString == null || utcIsoString.isEmpty) return '--';
    
    try {
      // .toLocal() is crucial here as parsed ISO strings are treated as UTC by default
      DateTime utcDate = DateTime.parse(utcIsoString).toUtc();
      DateTime localDate = utcDate.toLocal(); 
      
      return DateFormat(format).format(localDate);
    } catch (e) {
      return utcIsoString;
    }
  }

  // 2. Used when sending data TO the backend (e.g., selecting a booking slot)
  // Ensure it is always .toUtc().toIso8601String()
  static String formatToBackend(DateTime localDateTime) {
    return localDateTime.toUtc().toIso8601String();
  }
}
