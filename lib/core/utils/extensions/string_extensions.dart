import 'package:flutter/material.dart';

/// Extension methods for String
extension StringExtensions on String {
  /// Show toast message (using ScaffoldMessenger)
  /// Note: Requires BuildContext, consider using a global navigator key
  void toast(BuildContext? context) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(this),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
