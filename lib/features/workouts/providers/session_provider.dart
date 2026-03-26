import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/set_model.dart';
import '../models/workout_exercise_model.dart';
import '../services/workout_api_service.dart';
import '../../../core/service/local_storage_service.dart';
import '../provider/workout_provider.dart';

class SessionProvider extends ChangeNotifier {
  SessionProvider({WorkoutApiService? apiService})
    : _apiService = apiService ?? WorkoutApiService();

  final WorkoutApiService _apiService;

  final Map<String, List<SetModel>> _logs = {};
  bool _isSaving = false;
  String? _errorMessage;

  Map<String, List<SetModel>> get logs => _logs;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  void addSet(String exerciseId, SetModel set) {
    final sets = _logs[exerciseId] ?? <SetModel>[];
    _logs[exerciseId] = [...sets, set];
    notifyListeners();
  }

  void removeSet(String exerciseId, int index) {
    final sets = _logs[exerciseId];
    if (sets == null || index < 0 || index >= sets.length) return;
    final updated = [...sets]..removeAt(index);
    _logs[exerciseId] = updated;
    notifyListeners();
  }

  Future<bool> saveSetToBackend({
    required String exerciseId,
    required DateTime date,
    required int setNumber,
    required SetModel set,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.saveSet(
        exerciseId: exerciseId,
        date: date,
        setNumber: setNumber,
        set: set,
      );

      // Keep Session Log in sync even if the user saves only a single set.
      // We mirror the in-memory workout progress into local cache.
      final dateKey = _dateKey(date);
      final workoutProgressProvider = WorkoutProgressProvider();
      final localWorkouts = workoutProgressProvider
          .getWorkoutProgressForDate(date)
          .map(
            (wp) => WorkoutExerciseModel(
              exerciseId: wp.exerciseId,
              exerciseName: wp.exerciseName,
              date: date,
              sets: wp.sets
                  .map((ws) => SetModel(reps: ws.reps, weight: ws.weight))
                  .toList(),
            ),
          )
          .toList();

      final jsonValue =
          jsonEncode(localWorkouts.map((e) => e.toJson()).toList());
      await LocalStorageService.setWorkoutCache(dateKey, jsonValue);
      await LocalStorageService.addWorkoutCacheDate(dateKey);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveFullDay({
    required DateTime date,
    required List<WorkoutExerciseModel> workouts,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.saveFullDay(date: date, workouts: workouts);

      // Persist locally so the "Session Log" screen survives app restarts.
      final dateKey = _dateKey(date);
      final jsonValue = jsonEncode(workouts.map((e) => e.toJson()).toList());
      await LocalStorageService.setWorkoutCache(dateKey, jsonValue);
      await LocalStorageService.addWorkoutCacheDate(dateKey);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  String _dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
