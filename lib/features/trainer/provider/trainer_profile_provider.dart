import 'package:flutter/foundation.dart';
import '../data/models/book_session_request_model.dart';
import '../data/models/trainer_profile_response_model.dart';
import '../data/repository/trainer_repository.dart';
import '../utils/date_time_utils.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

enum SessionType { online, physical }

class TrainerProfileProvider extends ChangeNotifier {
  final TrainerRepository _repository = TrainerRepository();

  TrainerProfileInfo? _trainer;
  List<SessionPlanModel> _sessionPlans = [];
  SessionPlanModel? _selectedSessionPlan;
  List<DateInfo> _availableDates = [];
  List<String> _availableTimeSlots = [];

  String? _selectedDate;
  String? _selectedTimeSlot;
  bool _showBookingConfirmation = false;
  SessionType _sessionType = SessionType.online;

  bool _isLoading = false;
  String? _error;
  bool _isBooking = false;
  String? _bookingError;

  TrainerProfileInfo? get trainer => _trainer;
  List<SessionPlanModel> get sessionPlans => _sessionPlans;
  SessionPlanModel? get selectedSessionPlan => _selectedSessionPlan;
  List<DateInfo> get availableDates => _availableDates;
  List<String> get availableTimeSlots => _availableTimeSlots;

  String? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  bool get showBookingConfirmation => _showBookingConfirmation;
  SessionType get sessionType => _sessionType;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isBooking => _isBooking;
  String? get bookingError => _bookingError;

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

          // Combine dates from all session plans
          _availableDates = DateTimeUtils.parseAllAvailableDates(_sessionPlans);

          // Select first session plan by default if available
          if (_sessionPlans.isNotEmpty) {
            _selectedSessionPlan = _sessionPlans.first;
            _availableTimeSlots = DateTimeUtils.parseAvailableTimeSlots(
              _sessionPlans.first,
            );
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

  /// Select a session plan and update available dates/time slots
  void selectSessionPlan(SessionPlanModel plan) {
    _selectedSessionPlan = plan;
    _availableTimeSlots = DateTimeUtils.parseAvailableTimeSlots(plan);

    // Reset selections when plan changes
    _selectedDate = null;
    _selectedTimeSlot = null;

    notifyListeners();
  }

  void selectDate(String dateId) {
    _selectedDate = dateId;

    // Find which session plan this date belongs to and update time slots
    final dateInfo = _availableDates.firstWhere(
      (d) => d.dateId == dateId,
      orElse: () => _availableDates.isNotEmpty
          ? _availableDates.first
          : throw StateError('No dates available'),
    );

    // Find the session plan for this date
    final plan = _sessionPlans.firstWhere(
      (p) => p.id == dateInfo.sessionPlanId,
      orElse: () => _sessionPlans.first,
    );

    // Update selected session plan and time slots
    _selectedSessionPlan = plan;
    _availableTimeSlots = DateTimeUtils.parseAvailableTimeSlots(plan);

    // Reset time slot selection when date changes
    _selectedTimeSlot = null;

    notifyListeners();
  }

  void selectTimeSlot(String timeSlot) {
    print("seleted time : $timeSlot");
    _selectedTimeSlot = timeSlot;
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
        availableDates: _availableDates,
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

  void reset() {
    _trainer = null;
    _sessionPlans = [];
    _selectedSessionPlan = null;
    _availableDates = [];
    _availableTimeSlots = [];
    _selectedDate = null;
    _selectedTimeSlot = null;
    _showBookingConfirmation = false;
    _sessionType = SessionType.online;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
