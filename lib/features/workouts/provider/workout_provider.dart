import 'package:flutter/foundation.dart';

enum ExerciseLevel {
  beginner,
  intermediate,
  advanced,
}

enum ExerciseIntensity {
  low,
  moderate,
  high,
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.level = ExerciseLevel.intermediate,
    this.averageMinutes = 10,
    this.intensity = ExerciseIntensity.moderate,
    this.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    this.calories = 123,
    this.goodFor = const [],
    this.videoUrl,
    this.videoThumbnailUrl,
    this.videoDurationMinutes = 30,
  });

  final String id;
  final String name;
  final String imageUrl;
  final ExerciseLevel level;
  final int averageMinutes;
  final ExerciseIntensity intensity;
  final String description;
  final int calories;
  final List<String> goodFor;
  final String? videoUrl;
  final String? videoThumbnailUrl;
  final int videoDurationMinutes;
}

class ExercisesProvider extends ChangeNotifier {
  final List<Exercise> _exercises = [
    Exercise(
      id: '1',
      name: 'Push Ups',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
      level: ExerciseLevel.intermediate,
      averageMinutes: 10,
      intensity: ExerciseIntensity.moderate,
      calories: 123,
      goodFor: ['Chest', 'Triceps', 'Shoulders', 'Core'],
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      videoThumbnailUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      videoDurationMinutes: 30,
    ),
    const Exercise(
      id: '2',
      name: 'Squats',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
    ),
    const Exercise(
      id: '3',
      name: 'Bench Press',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
    ),
    const Exercise(
      id: '4',
      name: 'Dumbbell Press',
      imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
    ),
    const Exercise(
      id: '5',
      name: 'Lat Pulldown',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
    ),
    const Exercise(
      id: '6',
      name: 'Pull Ups',
      imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
    ),
    const Exercise(
      id: '7',
      name: 'Deadlift',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
    ),
    const Exercise(
      id: '8',
      name: 'Bicep Curls',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
    ),
  ];

  List<Exercise> _loggedExercises = [];
  String _searchQuery = '';

  List<Exercise> get exercises => _exercises;

  List<Exercise> get filteredExercises {
    if (_searchQuery.isEmpty) {
      return _exercises;
    }
    return _exercises
        .where((exercise) =>
            exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Exercise> get loggedExercises => _loggedExercises;

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void logExercise(Exercise exercise) {
    if (!_loggedExercises.any((e) => e.id == exercise.id)) {
      _loggedExercises.add(exercise);
      notifyListeners();
    }
  }

  void removeLoggedExercise(String exerciseId) {
    _loggedExercises.removeWhere((e) => e.id == exerciseId);
    notifyListeners();
  }

  bool isExerciseLogged(String exerciseId) {
    return _loggedExercises.any((e) => e.id == exerciseId);
  }
}

class WorkoutSet {
  const WorkoutSet({
    required this.reps,
    this.weight,
  });

  final int reps;
  final double? weight;
}

class WorkoutProgress {
  const WorkoutProgress({
    required this.exerciseId,
    required this.exerciseName,
    required this.date,
    required this.sets,
  });

  final String exerciseId;
  final String exerciseName;
  final DateTime date;
  final List<WorkoutSet> sets;

  WorkoutProgress copyWith({
    String? exerciseId,
    String? exerciseName,
    DateTime? date,
    List<WorkoutSet>? sets,
  }) {
    return WorkoutProgress(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      date: date ?? this.date,
      sets: sets ?? this.sets,
    );
  }
}

class WorkoutProgressProvider extends ChangeNotifier {
  static WorkoutProgressProvider? _instance;
  
  WorkoutProgressProvider._internal();
  
  factory WorkoutProgressProvider() {
    _instance ??= WorkoutProgressProvider._internal();
    return _instance!;
  }

  final Map<String, List<WorkoutProgress>> _workoutProgressByDate = {};

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<WorkoutProgress> getWorkoutProgressForDate(DateTime date) {
    final dateKey = _formatDate(date);
    return _workoutProgressByDate[dateKey] ?? [];
  }

  Map<String, List<WorkoutProgress>> getAllWorkoutProgress() {
    return Map.from(_workoutProgressByDate);
  }

  void addExerciseToWorkout(DateTime date, Exercise exercise) {
    final dateKey = _formatDate(date);
    final existingProgress = _workoutProgressByDate[dateKey] ?? [];

    if (!existingProgress.any((wp) => wp.exerciseId == exercise.id)) {
      final newProgress = WorkoutProgress(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        date: date,
        sets: [],
      );
      existingProgress.add(newProgress);
      _workoutProgressByDate[dateKey] = existingProgress;
      notifyListeners();
    }
  }

  void addSetToExercise(DateTime date, String exerciseId, WorkoutSet set) {
    final dateKey = _formatDate(date);
    final existingProgress = _workoutProgressByDate[dateKey] ?? [];
    final exerciseIndex = existingProgress.indexWhere((wp) => wp.exerciseId == exerciseId);

    if (exerciseIndex != -1) {
      final exerciseProgress = existingProgress[exerciseIndex];
      final updatedSets = [...exerciseProgress.sets, set];
      existingProgress[exerciseIndex] = exerciseProgress.copyWith(sets: updatedSets);
      _workoutProgressByDate[dateKey] = existingProgress;
      notifyListeners();
    }
  }

  void removeSetFromExercise(DateTime date, String exerciseId, int setIndex) {
    final dateKey = _formatDate(date);
    final existingProgress = _workoutProgressByDate[dateKey] ?? [];
    final exerciseIndex = existingProgress.indexWhere((wp) => wp.exerciseId == exerciseId);

    if (exerciseIndex != -1) {
      final exerciseProgress = existingProgress[exerciseIndex];
      final updatedSets = List<WorkoutSet>.from(exerciseProgress.sets);
      if (setIndex >= 0 && setIndex < updatedSets.length) {
        updatedSets.removeAt(setIndex);
        existingProgress[exerciseIndex] = exerciseProgress.copyWith(sets: updatedSets);
        _workoutProgressByDate[dateKey] = existingProgress;
        notifyListeners();
      }
    }
  }

  void updateSet(DateTime date, String exerciseId, int setIndex, WorkoutSet updatedSet) {
    final dateKey = _formatDate(date);
    final existingProgress = _workoutProgressByDate[dateKey] ?? [];
    final exerciseIndex = existingProgress.indexWhere((wp) => wp.exerciseId == exerciseId);

    if (exerciseIndex != -1) {
      final exerciseProgress = existingProgress[exerciseIndex];
      final updatedSets = List<WorkoutSet>.from(exerciseProgress.sets);
      if (setIndex >= 0 && setIndex < updatedSets.length) {
        updatedSets[setIndex] = updatedSet;
        existingProgress[exerciseIndex] = exerciseProgress.copyWith(sets: updatedSets);
        _workoutProgressByDate[dateKey] = existingProgress;
        notifyListeners();
      }
    }
  }

  void removeExerciseFromWorkout(DateTime date, String exerciseId) {
    final dateKey = _formatDate(date);
    final existingProgress = _workoutProgressByDate[dateKey] ?? [];
    existingProgress.removeWhere((wp) => wp.exerciseId == exerciseId);
    _workoutProgressByDate[dateKey] = existingProgress;
    notifyListeners();
  }
}

