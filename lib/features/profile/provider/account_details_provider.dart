import 'package:flutter/material.dart';

class AccountField {
  const AccountField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class AccountDetailsProvider extends ChangeNotifier {
  AccountDetailsProvider() {
    _fields = const [
      AccountField(label: 'Name', value: 'Aman Negi'),
      AccountField(label: 'Email', value: 'Aman Negi@demo.com'),
      AccountField(label: 'Gender', value: 'Male'),
      AccountField(label: 'Date of birth', value: '12 Dec 1998'),
      AccountField(label: 'Contact Number', value: '+44059622788977'),
      AccountField(label: 'Password', value: '************'),
    ];
    _values = _fields.map((field) => field.value).toList();
  }

  List<AccountField> _fields = [];
  List<String> _values = [];

  List<AccountField> get fields => _fields;
  List<String> get values => _values;

  void updateValue(int index, String value) {
    if (index >= 0 && index < _values.length) {
      _values[index] = value;
      notifyListeners();
    }
  }

  void save() {
    // TODO: Implement save logic (API call, etc.)
    // For now, just notify that save was called
  }
}

