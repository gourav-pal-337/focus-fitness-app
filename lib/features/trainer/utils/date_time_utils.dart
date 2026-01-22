import '../data/models/trainer_profile_response_model.dart';

/// Date info for date selector
class DateInfo {
  const DateInfo({
    required this.date,
    required this.day,
    required this.dateTime,
    required this.dateId,
    required this.sessionPlanId,
  });

  final String date; // Day of month as string: '9', '10', etc.
  final String day; // Day abbreviation: 'Mon', 'Tue', etc.
  final DateTime dateTime;
  final String dateId; // Unique identifier: '2026-01-10', etc.
  final String sessionPlanId; // ID of the session plan this date belongs to
}

/// Utility class for parsing dates and time slots from session plans
class DateTimeUtils {
  /// Parse available dates from all session plans and combine them
  static List<DateInfo> parseAllAvailableDates(List<SessionPlanModel> sessionPlans) {
    final allDates = <DateInfo>[];
    final seenDateIds = <String>{};
    
    for (final plan in sessionPlans) {
      final planDates = parseAvailableDates(plan);
      for (final dateInfo in planDates) {
        // Only add if we haven't seen this dateId before (avoid duplicates)
        if (!seenDateIds.contains(dateInfo.dateId)) {
          seenDateIds.add(dateInfo.dateId);
          allDates.add(dateInfo);
        }
      }
    }
    
    // Sort dates chronologically
    allDates.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    return allDates;
  }

  /// Parse available dates based on session plan's startDate, endDate
  static List<DateInfo> parseAvailableDates(SessionPlanModel sessionPlan) {
    final dates = <DateInfo>[];
    final now = DateTime.now();
    
    // Normalize to date only (remove time component)
    final today = DateTime(now.year, now.month, now.day);
    
    // Use startDate if available, otherwise use today
    DateTime startDate;
    if (sessionPlan.startDate != null) {
      final planStart = sessionPlan.startDate!;
      startDate = DateTime(planStart.year, planStart.month, planStart.day);
    } else {
      startDate = today;
    }
    
    // Use endDate if available, otherwise use 7 days from start
    DateTime endDate;
    if (sessionPlan.endDate != null) {
      final planEnd = sessionPlan.endDate!;
      endDate = DateTime(planEnd.year, planEnd.month, planEnd.day);
    } else {
      endDate = startDate.add(const Duration(days: 7));
    }
    
    // Use startDate as-is (even if in future) - don't force to today
    // This allows showing future dates from the API
    final effectiveStartDate = startDate;
    
    // Generate dates up to endDate or 7 days, whichever comes first
    final maxDays = endDate.difference(effectiveStartDate).inDays;
    final daysToShow = maxDays > 7 ? 7 : (maxDays < 0 ? 0 : maxDays + 1);
    
    for (int i = 0; i < daysToShow; i++) {
      final currentDate = effectiveStartDate.add(Duration(days: i));
      final dayOfMonth = currentDate.day;
      final dayName = _getDayAbbreviation(currentDate.weekday);
      // Create unique date ID: YYYY-MM-DD
      final dateId = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
      
      dates.add(DateInfo(
        date: dayOfMonth.toString(),
        day: dayName,
        dateTime: currentDate,
        dateId: dateId,
        sessionPlanId: sessionPlan.id,
      ));
    }
    
    return dates;
  }

  /// Parse available time slots based on session plan's timeSlots, timeStart/timeEnd, or durationMinutes
  static List<String> parseAvailableTimeSlots(SessionPlanModel sessionPlan) {
    final timeSlots = <String>[];
    
    // Priority 1: Use timeSlots array if available
    if (sessionPlan.timeSlots != null && sessionPlan.timeSlots!.isNotEmpty) {
      for (final slot in sessionPlan.timeSlots!) {
        final formattedTime = _formatTimeSlot(slot.startTime);
        if (formattedTime.isNotEmpty) {
          timeSlots.add(formattedTime);
        }
      }
      return timeSlots;
    }
    
    // Priority 2: Use timeStart and timeEnd if available
    if (sessionPlan.timeStart != null && sessionPlan.timeEnd != null) {
      final startTime = sessionPlan.timeStart!;
      final endTime = sessionPlan.timeEnd!;
      final durationMinutes = sessionPlan.durationMinutes;
      
      // Parse start and end times
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');
      
      if (startParts.length == 2 && endParts.length == 2) {
        final startHour = int.tryParse(startParts[0]) ?? 6;
        final startMinute = int.tryParse(startParts[1]) ?? 0;
        final endHour = int.tryParse(endParts[0]) ?? 22;
        final endMinute = int.tryParse(endParts[1]) ?? 0;
        
        final startDateTime = DateTime(2024, 1, 1, startHour, startMinute);
        final endDateTime = DateTime(2024, 1, 1, endHour, endMinute);
        
        // Generate time slots based on duration
        var currentTime = startDateTime;
        while (currentTime.isBefore(endDateTime) || currentTime.isAtSameMomentAs(endDateTime)) {
          final nextTime = currentTime.add(Duration(minutes: durationMinutes));
          
          // Check if next time slot fits within end time
          if (nextTime.isAfter(endDateTime)) {
            break;
          }
          
          final formattedTime = _formatTimeFromDateTime(currentTime);
          if (formattedTime.isNotEmpty) {
            timeSlots.add(formattedTime);
          }
          
          // Move to next slot based on duration
          currentTime = nextTime;
        }
      }
      return timeSlots;
    }
    
    // Priority 3: Default time range if nothing specified
    final defaultStart = '06:00';
    final defaultEnd = '22:00';
    final durationMinutes = sessionPlan.durationMinutes;
    
    final startParts = defaultStart.split(':');
    final endParts = defaultEnd.split(':');
    
    if (startParts.length == 2 && endParts.length == 2) {
      final startHour = int.tryParse(startParts[0]) ?? 6;
      final startMinute = int.tryParse(startParts[1]) ?? 0;
      final endHour = int.tryParse(endParts[0]) ?? 22;
      final endMinute = int.tryParse(endParts[1]) ?? 0;
      
      final startDateTime = DateTime(2024, 1, 1, startHour, startMinute);
      final endDateTime = DateTime(2024, 1, 1, endHour, endMinute);
      
      var currentTime = startDateTime;
      while (currentTime.isBefore(endDateTime) || currentTime.isAtSameMomentAs(endDateTime)) {
        final nextTime = currentTime.add(Duration(minutes: durationMinutes));
        
        if (nextTime.isAfter(endDateTime)) {
          break;
        }
        
        final formattedTime = _formatTimeFromDateTime(currentTime);
        if (formattedTime.isNotEmpty) {
          timeSlots.add(formattedTime);
        }
        
        currentTime = nextTime;
      }
    }
    
    return timeSlots;
  }

  /// Format time slot from string (e.g., "15:09" -> "3:09 pm")
  static String _formatTimeSlot(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) return '';
    
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    
    if (hour == null || minute == null) return '';
    
    return _formatTime(hour, minute);
  }

  /// Format time from DateTime
  static String _formatTimeFromDateTime(DateTime dateTime) {
    return _formatTime(dateTime.hour, dateTime.minute);
  }

  /// Format hour and minute to display format (e.g., 15, 9 -> "3:09 pm")
  static String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    
    return '$displayHour:$displayMinute $period';
  }

  static String _getDayAbbreviation(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  /// Format date ID to a readable date string (e.g., "Monday Jan 10, 2026")
  static String formatDateId(String dateId, List<DateInfo> availableDates) {
    final dateInfo = availableDates.firstWhere(
      (d) => d.dateId == dateId,
      orElse: () => availableDates.isNotEmpty
          ? availableDates.first
          : DateInfo(
              date: DateTime.now().day.toString(),
              day: 'Mon',
              dateTime: DateTime.now(),
              dateId: dateId,
              sessionPlanId: '',
            ),
    );
    
    final dateTime = dateInfo.dateTime;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    
    return '${weekdays[dateTime.weekday - 1]} ${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  /// Convert selected date and time slot to ISO timestamps
  /// [dateId] - The selected date ID (e.g., "2026-01-10")
  /// [timeSlot] - The selected time slot (e.g., "3:09 pm")
  /// [availableDates] - List of available dates to find the date
  /// [durationMinutes] - Duration of the session in minutes
  /// Returns a map with 'startTime' and 'endTime' as ISO 8601 strings
  static Map<String, String> convertToIsoTimestamps({
    required String dateId,
    required String timeSlot,
    required List<DateInfo> availableDates,
    required int durationMinutes,
  }) {
    print("Converting to ISO Timestamps for dateId: $dateId, timeSlot: $timeSlot");
    // Find the date info
    final dateInfo = availableDates.firstWhere(
      (d) => d.dateId == dateId,
      orElse: () => availableDates.isNotEmpty
          ? availableDates.first
          : throw StateError('Date not found'),
    );

    // Parse time slot (e.g., "3:09 pm" -> hour: 15, minute: 9)
    final timeParts = timeSlot.split(' ');
    if (timeParts.length != 2) {
      throw FormatException('Invalid time slot format: $timeSlot');
    }

    final timeString = timeParts[0]; // "3:09"
    final period = timeParts[1].toLowerCase(); // "pm" or "am"

    final timeComponents = timeString.split(':');
    if (timeComponents.length != 2) {
      throw FormatException('Invalid time format: $timeString');
    }

    var hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    // Convert to 24-hour format
    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    // Create DateTime for start time in UTC
    final startDateTime = DateTime.utc(
      dateInfo.dateTime.year,
      dateInfo.dateTime.month,
      dateInfo.dateTime.day,
      hour,
      minute,
    );

    // Create DateTime for end time (start + duration)
    final endDateTime = startDateTime.add(Duration(minutes: durationMinutes));

    // Convert to ISO 8601 format (already in UTC)
    final startTime = startDateTime.toIso8601String();
    final endTime = endDateTime.toIso8601String();

    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

