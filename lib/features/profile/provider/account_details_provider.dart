import 'package:flutter/material.dart';
import 'package:focus_fitness/features/profile/data/models/client_profile_model.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';
import '../../../core/service/local_storage_service.dart';
import '../../../features/authentication/data/models/register_response_model.dart'; // Assuming User model is here or import where User is defined. Wait, User is RegisterResponseModel? Or User model? Let's check UserProvider.
import '../data/models/update_client_profile_request_model.dart';
import '../data/services/profile_api_service.dart';

class AccountField {
  const AccountField({required this.label, required this.value});

  final String label;
  final String value;
}

class AccountDetailsProvider extends ChangeNotifier {
  AccountDetailsProvider();

  final ProfileApiService _apiService = ProfileApiService();
  List<AccountField> _fields = [];
  List<String> _values = [];
  bool _isLoading = false;
  bool _isSaving = false;

  List<AccountField> get fields => _fields;
  List<String> get values => _values;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> init(ClientProfileModel? user) async {
    _isLoading = true;
    notifyListeners();

    if (user != null) {
      _fields = [
        AccountField(label: 'Name', value: user.fullName ?? ''),
        AccountField(label: 'Email', value: user.email ?? ''),
        AccountField(label: 'Gender', value: user.gender ?? ''),
        // AccountField(
        //   label: 'Date of birth',
        //   value: _formatDate(
        //     user.dateOfBirth.toString(),
        //   ), // Placeholder or if user has DOB
        // ),
        AccountField(label: 'Contact Number', value: user.phone ?? ''),
        // AccountField(label: 'Password', value: '************'),
      ];
      _values = _fields.map((field) => field.value).toList();

      // Still fetch profile for DOB if it's not in user object
      // await _fetchProfileData(context);
    } else {
      // Fallback or empty
      _fields = [
        const AccountField(label: 'Name', value: ''),
        const AccountField(label: 'Email', value: ''),
        const AccountField(label: 'Gender', value: ''),
        // const AccountField(label: 'Date of birth', value: ''),
        const AccountField(label: 'Contact Number', value: ''),
        // const AccountField(label: 'Password', value: '************'),
      ];
      _values = _fields.map((field) => field.value).toList();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchProfileData(BuildContext context) async {
    try {
      final profileResponse = await _apiService.getClientProfile();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      String dob = '';
      if (profileResponse.profile?.dateOfBirth != null) {
        dob = _formatDate(profileResponse.profile!.dateOfBirth!);
      }

      _fields = [
        AccountField(label: 'Name', value: user?.fullName ?? ''),
        AccountField(label: 'Email', value: user?.email ?? ''),
        AccountField(label: 'Gender', value: user?.gender ?? ''),
        AccountField(label: 'Date of birth', value: dob),
        AccountField(label: 'Contact Number', value: user?.phone ?? ''),
        const AccountField(label: 'Password', value: '************'),
      ];
      _values = _fields.map((field) => field.value).toList();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return '';
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_getMonth(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getMonth(int month) {
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
      'Dec',
    ];
    return months[month - 1];
  }

  void updateValue(int index, String value) {
    if (index >= 0 && index < _values.length) {
      _values[index] = value;
      notifyListeners();
    }
  }

  Future<void> save() async {
    _isSaving = true;
    notifyListeners();

    try {
      final name = _values[0];
      // final email = _values[1];
      final gender = _values[2];
      final dobStr = _values[3];
      // final phone = _values[4];

      String? dateOfBirth;
      if (dobStr.isNotEmpty) {
        try {
          // Parse "12 Dec 1998" back to YYYY-MM-DD
          final parts = dobStr.split(' ');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month =
                [
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
                  'Dec',
                ].indexOf(parts[1]) +
                1;
            final year = int.parse(parts[2]);
            dateOfBirth =
                '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
          }
        } catch (e) {
          // try simple parse?
        }
      }

      // Note: Email and Phone are not being updated as they were removed from the request model
      final request = UpdateClientProfileRequestModel(
        fullName: name,
        dateOfBirth: dateOfBirth,
        gender: gender.isEmpty ? null : gender,
      );

      final response = await _apiService.updateClientProfile(request);

      if (response.success) {
        // Update local user storage if name/email changed?
        final user = await LocalStorageService.getUser();
        if (user != null) {
          // This part requires UserModel to have copyWith or similar, or create new
          // Since UserModel is immutable and no copyWith, maybe simple refetch or partial update?
          // The API response might return updated user?
          // UpdateClientProfileResponseModel usually contains success/message.
        }
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }

    _isSaving = false;
    notifyListeners();
  }
}
