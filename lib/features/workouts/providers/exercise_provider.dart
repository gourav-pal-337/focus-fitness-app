import 'package:flutter/foundation.dart';

import '../models/exercise_model.dart';
import '../services/workout_api_service.dart';

class ExerciseProvider extends ChangeNotifier {
  ExerciseProvider({WorkoutApiService? apiService})
    : _apiService = apiService ?? WorkoutApiService();

  final WorkoutApiService _apiService;

  List<ExerciseModel> _exercises = [];
  List<String> _categories = [];
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  List<ExerciseModel> get exercises => _exercises;
  List<String> get categories => _categories;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchExercises() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exercises = await _apiService.getExercises(
        query: _searchQuery,
        category: _selectedCategory,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchExerciseById(String exerciseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final exercise = await _apiService.getExerciseById(exerciseId);
      _exercises = [exercise];
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _exercises = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.getExerciseCategories();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> searchExercises(String query) async {
    _searchQuery = query;
    await fetchExercises();
  }

  Future<void> setCategory(String? category) async {
    _selectedCategory = category;
    await fetchExercises();
  }
}
