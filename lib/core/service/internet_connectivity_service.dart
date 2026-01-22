import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:focus_fitness/core/constants/global_keys.dart';

class InternetConnectivityService {
  static final InternetConnectivityService _instance =
      InternetConnectivityService._internal();

  factory InternetConnectivityService() => _instance;

  InternetConnectivityService._internal();

  static void init() {
    _instance._listenToConnectivityChanges();
  }

  bool _isToastVisible = false;

  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      debugPrint("Connectivity changed: $results");
      final bool hasNoInternet = results.contains(ConnectivityResult.none);

      if (hasNoInternet && !_isToastVisible) {
        _showNoInternetToast();
        _isToastVisible = true;
      } else if (!hasNoInternet && _isToastVisible) {
        _hideNoInternetToast();
        _isToastVisible = false;
      }
    });
  }

  void _showNoInternetToast() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
        duration: Duration(days: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  void _hideNoInternetToast() {
    rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }
}
