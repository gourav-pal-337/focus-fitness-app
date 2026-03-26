import '../../../core/constants/api_endpoints.dart';
import '../models/exercise_model.dart';
import '../models/manual_model.dart';
import '../models/set_model.dart';
import '../models/workout_exercise_model.dart';
import 'base_service.dart';

class WorkoutApiService {
  WorkoutApiService({BaseService? baseService})
    : _baseService = baseService ?? BaseService();

  final BaseService _baseService;

  Future<ExerciseModel> getExerciseById(String exerciseId) async {
    final response = await _baseService.get('${Endpoints.exercises}/$exerciseId');

    // Common wrapper shapes:
    // - { data: { ...exercise } }
    // - { exercise: { ...exercise } }
    // - { ...exercise directly }
    final dynamic candidate =
        response['data'] ?? response['exercise'] ?? response;

    if (candidate is Map<String, dynamic>) {
      return ExerciseModel.fromJson(candidate);
    }

    // Fallback: try treating the response as the exercise payload.
    return ExerciseModel.fromJson(response);
  }

  Future<List<WorkoutExerciseModel>> getWorkoutProgressByDate(
    DateTime date,
  ) async {
    final apiDate = _dateToApi(date);
    final response = await _baseService.get(
      Endpoints.workoutProgress,
      queryParameters: {'date': apiDate},
    );

    // Backend currently returns: { success: true, progress: [ ... ] }
    final list = _extractList(
      response,
      keys: ['progress', 'workouts', 'data', 'results'],
    );
    return list.map(WorkoutExerciseModel.fromJson).toList();
  }

  Future<void> saveSet({
    required String exerciseId,
    required DateTime date,
    required int setNumber,
    required SetModel set,
  }) async {
    final apiDate = _dateToApi(date);
    await _baseService.post(
      Endpoints.workoutSaveSet,
      body: {
        'exerciseId': exerciseId,
        'date': apiDate,
        'setNumber': setNumber,
        'reps': set.reps,
        if (set.weight != null) 'weight': set.weight,
      },
    );
  }

  Future<void> saveFullDay({
    required DateTime date,
    required List<WorkoutExerciseModel> workouts,
  }) async {
    final apiDate = _dateToApi(date);
    await _baseService.post(
      Endpoints.workoutSaveDay,
      body: {
        'date': apiDate,
        'workouts': workouts.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<List<ExerciseModel>> getExercises({String? query, String? category}) async {
    final response = await _baseService.get(
      Endpoints.exercises,
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );

    final list = _extractList(response, keys: ['exercises', 'data', 'results']);
    return list.map(ExerciseModel.fromJson).toList();
  }

  Future<List<String>> getExerciseCategories() async {
    final response = await _baseService.get(Endpoints.exerciseCategories);
    final data = response['data'];
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    final categories = response['categories'];
    if (categories is List) {
      return categories.map((e) => e.toString()).toList();
    }

    return const <String>[];
  }

  Future<List<ManualModel>> getManuals() async {
    final response = await _baseService.get(Endpoints.workoutManuals);
    final list = _extractList(response, keys: ['manuals', 'data', 'results']);
    return list.map(ManualModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _extractList(
    Map<String, dynamic> json, {
    required List<String> keys,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) {
        return value.whereType<Map<String, dynamic>>().toList();
      }

      // Handle nested structures like: { data: { workouts: [...] } }
      if (value is Map<String, dynamic>) {
        for (final innerKey in keys) {
          final nestedValue = value[innerKey];
          if (nestedValue is List) {
            return nestedValue
                .whereType<Map<String, dynamic>>()
                .toList();
          }
        }
      }
    }
    return const <Map<String, dynamic>>[];
  }

  String _dateToApi(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }
}
