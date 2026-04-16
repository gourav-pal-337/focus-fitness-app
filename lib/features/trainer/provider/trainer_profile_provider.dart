import 'package:flutter/foundation.dart';
import '../data/models/book_session_request_model.dart';
import '../data/models/trainer_profile_response_model.dart';
import '../data/models/next_available_slot_response_model.dart';
import '../data/repository/trainer_repository.dart';
import '../../session/data/models/reschedule_models.dart';
import '../utils/date_time_utils.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

enum SessionType { online, inPerson }

class TrainerProfileProvider extends ChangeNotifier {
  final TrainerRepository _repository = TrainerRepository();

  TrainerProfileInfo? _trainer;
  List<SessionPlanModel> _sessionPlans = [];
  SessionPlanModel? _selectedSessionPlan;
  List<DayAvailability> _availability = [];

  String? _selectedDate;
  String? _selectedMonth;
  String? _selectedTimeSlot;
  bool _showBookingConfirmation = false;
  SessionType _sessionType = SessionType.online;

  bool _isLoading = false;
  String? _error;
  bool _isBooking = false;
  String? _bookingError;
  bool _isCheckingAvailability = false;
  bool _isSlotAvailable = true;
  String? _availabilityCheckError;

  bool _isLoadingNextSlot = false;
  AvailableSlotModel? _nextAvailableSlot;
  String? _nextSlotError;

  TrainerProfileInfo? get trainer => _trainer;
  List<SessionPlanModel> get sessionPlans => _sessionPlans;
  SessionPlanModel? get selectedSessionPlan => _selectedSessionPlan;
  List<DayAvailability> get availability => _availability;

  String? get selectedDate => _selectedDate;
  String? get selectedMonth => _selectedMonth;
  String? get selectedTimeSlot => _selectedTimeSlot;

  bool get isLoadingNextSlot => _isLoadingNextSlot;
  AvailableSlotModel? get nextAvailableSlot => _nextAvailableSlot;
  String? get nextSlotError => _nextSlotError;

  List<DateInfo> get availableDates {
    if (_availability.isEmpty) return [];

    // Map DayAvailability to DateInfo for compatibility with the existing DateSelector
    return _availability.map((day) {
      final dateTime = DateTime.parse(day.date);

      return DateInfo(
        date: dateTime.day.toString(),
        day: DateTimeUtils.getDayAbbreviation(dateTime.weekday),
        month: DateTimeUtils.getMonthAbbreviation(dateTime.month),
        dateTime: dateTime,
        dateId: day.date,
        sessionPlanId: day.availableSlots.isNotEmpty
            ? day.availableSlots.first.planId ?? ''
            : '',
      );
    }).toList();
  }

  List<String> get availableTimeSlots {
    if (_selectedDate == null) return [];

    final dayAvail = _availability.firstWhere(
      (d) => d.date == _selectedDate,
      orElse: () => DayAvailability(date: '', availableSlots: []),
    );

    final slots = dayAvail.availableSlots.map((slot) {
      final dateTime = DateTime.parse(slot.startTime);
      return DateTimeUtils.formatTime(dateTime.hour, dateTime.minute);
    }).toList();

    return slots..sort();
  }

  List<String> get uniqueMonths {
    return availableDates.map((d) => d.month).toSet().toList();
  }

  bool get showBookingConfirmation => _showBookingConfirmation;
  SessionType get sessionType => _sessionType;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isBooking => _isBooking;
  String? get bookingError => _bookingError;
  bool get isCheckingAvailability => _isCheckingAvailability;
  bool get isSlotAvailable => _isSlotAvailable;
  String? get availabilityCheckError => _availabilityCheckError;

  bool get canBookSession => _selectedDate != null && _selectedTimeSlot != null;

  /// Fetch trainer profile with session plans
  Future<void> fetchTrainerProfile(String trainerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getTrainerProfile(trainerId);

      await result.when(
        success: (response) async {
          _trainer = response.trainer;
          _sessionPlans = response.sessionPlans;

          // Generate availability from all session plans
          _availability = _generateAvailability(_sessionPlans);

          // Initialize with the first available date if possible
          if (_availability.isNotEmpty) {
            _selectedDate = _availability.first.date;

            // Set first matching plan as default
            final firstSlot = _availability.first.availableSlots.first;
            final matchingPlans = _sessionPlans
                .where((p) => p.id == firstSlot.planId)
                .toList();
            if (matchingPlans.isNotEmpty) {
              _selectedSessionPlan = matchingPlans.first;
            }
          } else if (_sessionPlans.isNotEmpty) {
            _selectedSessionPlan = _sessionPlans.first;
          }

          // Initialize selected month
          if (availableDates.isNotEmpty) {
            _selectedMonth = availableDates.first.month;
          }

          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        failure: (message, code) {
          _isLoading = false;
          _error = message;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Check if session plan is selected and slot is available
  bool get canProceedToBooking =>
      _selectedDate != null &&
      _selectedTimeSlot != null &&
      _isSlotAvailable &&
      !_isCheckingAvailability;

  /// Check trainer availability for the selected time slot
  Future<bool> checkSlotAvailability() async {
    if (_trainer == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null ||
        _selectedSessionPlan == null) {
      return false;
    }

    _isCheckingAvailability = true;
    _availabilityCheckError = null;
    notifyListeners();

    try {
      final timestamps = DateTimeUtils.convertToIsoTimestamps(
        dateId: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        availableDates: availableDates,
        durationMinutes: _selectedSessionPlan!.durationMinutes,
      );

      final result = await _repository.checkTrainerBooking(
        trainerId: _trainer!.id,
        startTime: timestamps['startTime']!,
        endTime: timestamps['endTime']!,
      );

      return await result.when(
        success: (response) async {
          _isCheckingAvailability = false;
          _isSlotAvailable = !response.hasBooking;
          if (response.hasBooking) {
            _availabilityCheckError =
                'This slot is no longer available. Please choose another time.';
          }
          notifyListeners();
          return _isSlotAvailable;
        },
        failure: (message, code) {
          _isCheckingAvailability = false;
          _availabilityCheckError = message;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _isCheckingAvailability = false;
      _availabilityCheckError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Select a session plan (Legacy support, resets availability-based selections)
  void selectSessionPlan(SessionPlanModel plan) {
    _selectedSessionPlan = plan;
    _selectedDate = null;
    _selectedTimeSlot = null;

    notifyListeners();
  }

  void selectDate(String dateId) {
    _selectedDate = dateId;

    // Default plan selection for this date (from the first slot of the day)
    final dayAvail = _availability.firstWhere(
      (d) => d.date == dateId,
      orElse: () => DayAvailability(date: '', availableSlots: []),
    );

    if (dayAvail.availableSlots.isNotEmpty) {
      final planId = dayAvail.availableSlots.first.planId;
      final matchingPlans = _sessionPlans.where((p) => p.id == planId).toList();
      if (matchingPlans.isNotEmpty) {
        _selectedSessionPlan = matchingPlans.first;
      }
    }

    // Reset time slot selection when date changes
    _selectedTimeSlot = null;
    _isSlotAvailable = true;
    _availabilityCheckError = null;

    notifyListeners();
  }

  void selectTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    _isSlotAvailable = true;
    _availabilityCheckError = null;

    // Identify which session plan this time slot belongs to for the selected date
    if (_selectedDate != null) {
      final dayAvail = _availability.firstWhere(
        (d) => d.date == _selectedDate,
        orElse: () => DayAvailability(date: '', availableSlots: []),
      );

      final matchingSlot = dayAvail.availableSlots.firstWhere((slot) {
        final dateTime = DateTime.parse(slot.startTime);
        final formatted = DateTimeUtils.formatTime(
          dateTime.hour,
          dateTime.minute,
        );
        return formatted == timeSlot;
      }, orElse: () => dayAvail.availableSlots.first);

      final matchingPlans = _sessionPlans
          .where((p) => p.id == matchingSlot.planId)
          .toList();
      if (matchingPlans.isNotEmpty) {
        _selectedSessionPlan = matchingPlans.first;
      }
    }

    notifyListeners();
  }

  /// Generate discrete availability from session plan templates
  List<DayAvailability> _generateAvailability(List<SessionPlanModel> plans) {
    final Map<String, List<RescheduleSlot>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final plan in plans) {
      final dateInfos = DateTimeUtils.parseAvailableDates(plan);
      final templateSlots = DateTimeUtils.parseAvailableTimeSlots(plan);

      for (final dateInfo in dateInfos) {
        // Filter out past dates
        if (dateInfo.dateTime.isBefore(today)) continue;

        final dateId = dateInfo.dateId;
        if (!grouped.containsKey(dateId)) {
          grouped[dateId] = [];
        }

        for (final slotStr in templateSlots) {
          final timestamps = DateTimeUtils.convertToIsoTimestamps(
            dateId: dateId,
            timeSlot: slotStr,
            availableDates: dateInfos,
            durationMinutes: plan.durationMinutes,
          );

          grouped[dateId]!.add(
            RescheduleSlot(
              date: dateId,
              startTime: timestamps['startTime']!,
              endTime: timestamps['endTime']!,
              planId: plan.id,
            ),
          );
        }
      }
    }

    final availability = grouped.entries.map((e) {
      return DayAvailability(date: e.key, availableSlots: e.value);
    }).toList();

    // Sort by date and then by time
    availability.sort((a, b) => a.date.compareTo(b.date));
    for (final day in availability) {
      day.availableSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return availability;
  }

  void selectMonth(String month) {
    if (_selectedMonth == month) return;
    _selectedMonth = month;
    // Reset selected date when month changes if it doesn't belong to the new month
    if (_selectedDate != null) {
      final matchingDates = availableDates
          .where((d) => d.dateId == _selectedDate)
          .toList();
      if (matchingDates.isNotEmpty) {
        final dateInfo = matchingDates.first;
        if (dateInfo.month != month) {
          _selectedDate = null;
          _selectedTimeSlot = null;
        }
      }
    }
    notifyListeners();
  }

  void setSessionType(SessionType type) {
    _sessionType = type;
    notifyListeners();
  }

  void showBookingView() {
    _showBookingConfirmation = true;
    notifyListeners();
  }

  void hideBookingView() {
    _showBookingConfirmation = false;
    notifyListeners();
  }

  /// Book a session
  Future<bool> bookSession({String? notes}) async {
    if (_trainer == null ||
        _selectedSessionPlan == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      _bookingError = 'Please select date and time slot';
      notifyListeners();
      return false;
    }

    _isBooking = true;
    _bookingError = null;
    notifyListeners();

    try {
      debugPrint("selected time : ${_selectedTimeSlot}");

      // Convert date and time slot to ISO timestamps
      final timestamps = DateTimeUtils.convertToIsoTimestamps(
        dateId: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        availableDates: availableDates,
        durationMinutes: _selectedSessionPlan!.durationMinutes,
      );

      debugPrint("timestamps : ${timestamps}");

      // Create request model
      final request = BookSessionRequestModel(
        trainerId: _trainer!.id,
        sessionPlanId: _selectedSessionPlan!.id,
        startTime: timestamps['startTime']!,
        endTime: timestamps['endTime']!,
        timezone: 'UTC', // You can get this from device timezone if needed
        notes: notes,
        mode: _sessionType.name,
      );

      final result = await _repository.bookSession(request);

      return await result.when(
        success: (response) async {
          _isBooking = false;
          _bookingError = null;
          notifyListeners();
          return response.success;
        },
        failure: (message, code) {
          _isBooking = false;
          _bookingError = message;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _isBooking = false;
      _bookingError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Fetch next available slot for the trainer
  Future<void> fetchNextAvailableSlot(String trainerId) async {
    _isLoadingNextSlot = true;
    _nextSlotError = null;
    notifyListeners();

    try {
      final result = await _repository.getNextAvailableSlot(trainerId);

      await result.when(
        success: (response) async {
          _nextAvailableSlot = response.availableSlot;
          _isLoadingNextSlot = false;
          _nextSlotError = response.message;
          notifyListeners();
        },
        failure: (message, code) {
          _isLoadingNextSlot = false;
          _nextSlotError = message;
          _nextAvailableSlot = null;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoadingNextSlot = false;
      _nextSlotError = e.toString().replaceAll('Exception: ', '');
      _nextAvailableSlot = null;
      notifyListeners();
    }
  }

  void reset() {
    _trainer = null;
    _sessionPlans = [];
    _selectedSessionPlan = null;
    _availability = [];
    _selectedMonth = null;
    _selectedDate = null;
    _selectedTimeSlot = null;
    _showBookingConfirmation = false;
    _sessionType = SessionType.online;
    _isLoading = false;
    _error = null;
    _nextAvailableSlot = null;
    _isLoadingNextSlot = false;
    _nextSlotError = null;
    notifyListeners();
  }
}
