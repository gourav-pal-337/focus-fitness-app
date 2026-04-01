import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../../core/service/local_storage_service.dart';
import '../models/today_workout_summary_model.dart';
import '../models/weekly_progress_model.dart';
import '../models/workout_exercise_model.dart';
import '../services/workout_api_service.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider._internal(this._apiService);

  static WorkoutProvider? _instance;

  factory WorkoutProvider({WorkoutApiService? apiService}) {
    _instance ??= WorkoutProvider._internal(apiService ?? WorkoutApiService());
    return _instance!;
  }

  final WorkoutApiService _apiService;

  List<WorkoutExerciseModel> _workouts = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  String? _errorMessage;
  DateTime? _lastFetchedDate;

  TodayWorkoutSummaryModel? _todaySummary;
  bool _isSummaryLoading = false;

  List<WeeklyProgressModel> _weeklyProgress = [];
  bool _isWeeklyLoading = false;

  List<WorkoutExerciseModel> get workouts => _workouts;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  String? get errorMessage => _errorMessage;

  TodayWorkoutSummaryModel? get todaySummary => _todaySummary;
  bool get isSummaryLoading => _isSummaryLoading;

  List<WeeklyProgressModel> get weeklyProgress => _weeklyProgress;
  bool get isWeeklyLoading => _isWeeklyLoading;

  Future<void> fetchWeeklyProgress() async {
    _isWeeklyLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weeklyProgress = await _apiService.getWeeklyProgress();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isWeeklyLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodaySummary() async {
    _isSummaryLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todaySummary = await _apiService.getTodayWorkoutSummary();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSummaryLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWorkoutByDate(DateTime date, {bool force = false}) async {
    debugPrint('fetchWorkoutByDate: $date');
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedToday = DateTime.now();
    final isToday =
        normalizedDate.year == normalizedToday.year &&
        normalizedDate.month == normalizedToday.month &&
        normalizedDate.day == normalizedToday.day;

    _selectedDate = normalizedDate;
    debugPrint('normalizedDate: $normalizedDate');
    // Fast path: load cached workout for today to avoid extra API calls.
    if (isToday && !force) {
      debugPrint('isToday: $isToday');
      final dateKey = _dateKey(normalizedDate);
      final cachedJson = await LocalStorageService.getWorkoutCache(dateKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(cachedJson);
          if (decoded is List) {
            _workouts = decoded
                .whereType<Map<String, dynamic>>()
                .map(WorkoutExerciseModel.fromJson)
                .toList();
            _lastFetchedDate = normalizedDate;
            _errorMessage = null;
            notifyListeners();
            return;
          }
        } catch (_) {
          // Ignore cache parse errors and fall back to API.
        }
      }
    }
    debugPrint('normalizedDate lastFetchedDate: $_lastFetchedDate');
    final shouldSkip =
        !force &&
        _lastFetchedDate != null &&
        _lastFetchedDate!.year == normalizedDate.year &&
        _lastFetchedDate!.month == normalizedDate.month &&
        _lastFetchedDate!.day == normalizedDate.day;

    if (shouldSkip) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    debugPrint('shouldSkip: $shouldSkip');
    try {
      _workouts = await _apiService.getWorkoutProgressByDate(normalizedDate);
      _lastFetchedDate = normalizedDate;

      // Cache today only (per UX/performance requirement).
      if (isToday) {
        final dateKey = _dateKey(normalizedDate);
        final cacheJson = jsonEncode(_workouts.map((e) => e.toJson()).toList());
        await LocalStorageService.setWorkoutCache(dateKey, cacheJson);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchWorkoutByDate(_selectedDate, force: true);
  }

  String _dateKey(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
