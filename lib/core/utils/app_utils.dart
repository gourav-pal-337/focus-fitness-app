import 'dart:io';

import 'package:flutter/foundation.dart';

/// Checks internet connection availability
Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
