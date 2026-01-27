import 'package:flutter/material.dart';

import '../data/models/update_client_profile_request_model.dart';
import '../data/services/profile_api_service.dart';
import '../ui/edit_profile_details_screen.dart';

/// Section types for edit profile screen
enum EditProfileSection { personalDetails, fitnessGoals }

class EditProfileDetailsProvider extends ChangeNotifier {
  EditProfileDetailsProvider({
    required List<EditField> fields,
    required this.section,
  }) : _fields = fields,
       _apiService = ProfileApiService() {
    _values = fields.map((field) => field.value).toList();
  }

  final List<EditField> _fields;
  final EditProfileSection section;
  final ProfileApiService _apiService;

  List<String> _values = [];
  bool _isSaving = false;
  String? _error;

  List<EditField> get fields => _fields;
  List<String> get values => _values;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void updateValue(int index, String value) {
    if (index >= 0 && index < _values.length) {
      _values[index] = value;
      notifyListeners();
    }
  }

  /// Save updated values to backend using Update Client Profile API
  Future<bool> save() async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final request = _buildRequest();
      final response = await _apiService.updateClientProfile(request);
      _isSaving = false;
      notifyListeners();
      return response.success;
    } catch (e) {
      _isSaving = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  UpdateClientProfileRequestModel _buildRequest() {
    switch (section) {
      case EditProfileSection.personalDetails:
        return _buildPersonalDetailsRequest();
      case EditProfileSection.fitnessGoals:
        return _buildFitnessGoalsRequest();
    }
  }

  UpdateClientProfileRequestModel _buildPersonalDetailsRequest() {
    String? _getValue(String label) {
      final index = _fields.indexWhere((f) => f.label == label);
      if (index == -1) return null;
      final value = _values[index].trim();
      return value.isEmpty ? null : value;
    }

    double? _parseDouble(String? value) {
      if (value == null) return null;
      final numeric = value.replaceAll(RegExp(r'[^0-9.]'), '');
      if (numeric.isEmpty) return null;
      return double.tryParse(numeric);
    }

    final dobStr = _getValue('DOB');
    final heightStr = _getValue('Height');
    final weightStr = _getValue('Weight');
    final fitnessLevel = _getValue('Fitness Level');

    // Parse DOB - if it's in display format, convert to ISO format
    String? dateOfBirth;
    DateTime? birthDate;
    if (dobStr != null && dobStr.isNotEmpty) {
      try {
        // Try parsing as ISO format first (YYYY-MM-DD)
        birthDate = DateTime.parse(dobStr);
        dateOfBirth =
            '${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}';
      } catch (e) {
        // If not ISO format, try parsing display format (e.g., "Jan 15, 1990")
        try {
          final months = {
            'Jan': 1,
            'Feb': 2,
            'Mar': 3,
            'Apr': 4,
            'May': 5,
            'Jun': 6,
            'Jul': 7,
            'Aug': 8,
            'Sep': 9,
            'Oct': 10,
            'Nov': 11,
            'Dec': 12,
          };
          final parts = dobStr.split(' ');
          if (parts.length == 3 && months.containsKey(parts[0])) {
            final month = months[parts[0]]!;
            final day = int.parse(parts[1].replaceAll(',', ''));
            final year = int.parse(parts[2]);
            birthDate = DateTime(year, month, day);
            dateOfBirth =
                '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
          } else {
            dateOfBirth = dobStr; // Use as-is if can't parse
          }
        } catch (e2) {
          dateOfBirth = dobStr; // Use as-is if can't parse
        }
      }
    }

    // Calculate age from DOB
    int? calculatedAge;
    if (birthDate != null) {
      final today = DateTime.now();
      calculatedAge = today.year - birthDate.year;
      // Adjust if birthday hasn't occurred this year
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        calculatedAge--;
      }
    }

    return UpdateClientProfileRequestModel(
      dateOfBirth: dateOfBirth,
      age: calculatedAge,
      height: _parseDouble(heightStr),
      weight: _parseDouble(weightStr),
      fitnessLevel: fitnessLevel,
    );
  }

  UpdateClientProfileRequestModel _buildFitnessGoalsRequest() {
    String? _getValue(String label) {
      final index = _fields.indexWhere((f) => f.label == label);
      if (index == -1) return null;
      final value = _values[index].trim();
      return value.isEmpty ? null : value;
    }

    final weightGoal = _getValue('Weight Goal');
    final bodyType = _getValue('Body Type');
    final performanceGoal = _getValue('Performance Goal');

    return UpdateClientProfileRequestModel(
      weightGoal: weightGoal,
      bodyType: bodyType,
      performanceGoal: performanceGoal,
    );
  }
}
