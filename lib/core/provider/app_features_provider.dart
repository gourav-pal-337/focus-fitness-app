import 'package:flutter/foundation.dart';
import '../../features/authentication/data/repository/auth_repository.dart';
import '../../features/trainer/data/models/app_features_model.dart';
import '../../features/trainer/data/repository/system_settings_repository.dart';

class AppFeaturesProvider extends ChangeNotifier {
  final SystemSettingsRepository _repository = SystemSettingsRepository();

  AppFeatures? _features;
  bool _isLoading = false;
  String? _error;

  AppFeatures? get features => _features;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch all app features from backend
  Future<void> fetchFeatures() async {
    print("Fetching app features...");
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getAppFeatures();

    result.when(
      success: (response) async {
        _features = response.features;
        _isLoading = false;
        notifyListeners();
      },
      failure: (message, code) {
        print("Error fetching app features: $message (code: $code)");
        _error = message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Check if a specific feature is enabled
  bool isEnabled(bool Function(AppFeatures) selector) {
    if (_features == null)
      return true; // Default to true if not loaded yet or fail-safe
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
