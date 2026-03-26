import 'package:flutter/foundation.dart';

import '../models/manual_model.dart';
import '../services/workout_api_service.dart';

class ManualProvider extends ChangeNotifier {
  ManualProvider({WorkoutApiService? apiService})
    : _apiService = apiService ?? WorkoutApiService();

  final WorkoutApiService _apiService;

  List<ManualModel> _manuals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ManualModel> get manuals => _manuals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchManuals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _manuals = await _apiService.getManuals();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
