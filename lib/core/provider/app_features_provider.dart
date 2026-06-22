import 'package:flutter/foundation.dart';
import '../config/app_features_config.dart';
import '../../features/trainer/data/models/app_features_model.dart';

/// Provides app feature flags from the build-time [kAppFeaturesConfig].
///
/// Flags are shipped inside the binary (no backend fetch), so what App Review
/// sees is exactly what ships. To enable/disable a module, edit
/// `lib/core/config/app_features_config.dart` and release a new build.
class AppFeaturesProvider extends ChangeNotifier {
  // Initialized synchronously from the local config so flags are available
  // immediately on first frame — no loading state, no network round-trip.
  AppFeatures? _features = AppFeatures.fromJson(kAppFeaturesConfig);

  AppFeatures? get features => _features;

  // No async loading or backend errors with a local config; kept for
  // call-site compatibility.
  bool get isLoading => false;
  String? get error => null;

  /// Loads feature flags from the local build-time config.
  ///
  /// Kept as a `Future` so existing call sites (e.g. `..fetchFeatures()`)
  /// continue to work unchanged. Performs no network I/O.
  Future<void> fetchFeatures() async {
    _features = AppFeatures.fromJson(kAppFeaturesConfig);
    notifyListeners();
  }

  /// Check if a specific feature is enabled
  bool isEnabled(bool Function(AppFeatures) selector) {
    if (_features == null) return true;
    return selector(_features!);
  }

  /// Convenience methods for common checks
  bool get isEmailAuthEnabled => _features?.auth.emailAuth ?? true;
  bool get isSocialAuthEnabled => _features?.auth.socialAuth ?? true;
  bool get isTrainerDiscoveryEnabled =>
      _features?.trainer.trainerDiscovery ?? true;
  bool get isWorkoutProgressEnabled =>
      _features?.workouts.workoutProgress ?? true;
  bool get isSubscriptionsEnabled =>
      _features?.finance.subscriptionOffers ?? true;
  bool get isSupportTicketsEnabled => _features?.support.supportTickets ?? true;
  bool get isFaqSystemEnabled => _features?.support.faqSystem ?? true;
  bool get isNotificationsEnabled => _features?.support.notifications ?? true;

  // Workout features
  bool get isWorkoutManualsEnabled => _features?.workouts.workoutManuals ?? true;
  bool get isWorkoutLoggingEnabled =>
      _features?.workouts.activeWorkoutLogging ?? true;
  bool get isSessionLogsEnabled => _features?.workouts.sessionLogs ?? true;
  bool get isExerciseLibraryEnabled =>
      _features?.workouts.exerciseLibrary ?? true;

  // Booking features
  bool get isSessionSchedulingEnabled =>
      _features?.bookings.sessionScheduling ?? true;
  bool get isSessionManagementEnabled =>
      _features?.bookings.sessionManagement ?? true;
  bool get isSessionSummariesEnabled =>
      _features?.bookings.sessionSummaries ?? true;
  bool get isRatingFeedbackEnabled =>
      _features?.bookings.ratingFeedback ?? true;

  // Home features
  bool get isWhatsappEnabled => _features?.home.whatsapp ?? true;
}
