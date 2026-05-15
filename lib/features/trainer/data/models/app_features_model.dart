class AppFeaturesResponseModel {
  final bool success;
  final AppFeatures features;

  AppFeaturesResponseModel({
    required this.success,
    required this.features,
  });

  factory AppFeaturesResponseModel.fromJson(Map<String, dynamic> json) {
    return AppFeaturesResponseModel(
      success: json['success'] as bool? ?? false,
      features: AppFeatures.fromJson(json['features'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class AppFeatures {
  final AuthFeatures auth;
  final TrainerFeatures trainer;
  final WorkoutFeatures workouts;
  final BookingFeatures bookings;
  final FinanceFeatures finance;
  final SupportFeatures support;
  final ProfileFeatures profile;
  final HomeFeatures home;

  AppFeatures({
    required this.auth,
    required this.trainer,
    required this.workouts,
    required this.bookings,
    required this.finance,
    required this.support,
    required this.profile,
    required this.home,
  });

  factory AppFeatures.fromJson(Map<String, dynamic> json) {
    return AppFeatures(
      auth: AuthFeatures.fromJson(json['auth'] as Map<String, dynamic>? ?? {}),
      trainer: TrainerFeatures.fromJson(json['trainer'] as Map<String, dynamic>? ?? {}),
      workouts: WorkoutFeatures.fromJson(json['workouts'] as Map<String, dynamic>? ?? {}),
      bookings: BookingFeatures.fromJson(json['bookings'] as Map<String, dynamic>? ?? {}),
      finance: FinanceFeatures.fromJson(json['finance'] as Map<String, dynamic>? ?? {}),
      support: SupportFeatures.fromJson(json['support'] as Map<String, dynamic>? ?? {}),
      profile: ProfileFeatures.fromJson(json['profile'] as Map<String, dynamic>? ?? {}),
      home: HomeFeatures.fromJson(json['home'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class AuthFeatures {
  final bool emailAuth;
  final bool socialAuth;
  final bool multiChannelOtp;
  final bool tfa;
  final bool passwordManagement;

  AuthFeatures({
    required this.emailAuth,
    required this.socialAuth,
    required this.multiChannelOtp,
    required this.tfa,
    required this.passwordManagement,
  });

  factory AuthFeatures.fromJson(Map<String, dynamic> json) {
    return AuthFeatures(
      emailAuth: json['emailAuth'] as bool? ?? true,
      socialAuth: json['socialAuth'] as bool? ?? true,
      multiChannelOtp: json['multiChannelOtp'] as bool? ?? true,
      tfa: json['tfa'] as bool? ?? true,
      passwordManagement: json['passwordManagement'] as bool? ?? true,
    );
  }
}

class TrainerFeatures {
  final bool trainerLinking;
  final bool trainerDiscovery;
  final bool trainerProfiles;
  final bool trainerUnlinking;

  TrainerFeatures({
    required this.trainerLinking,
    required this.trainerDiscovery,
    required this.trainerProfiles,
    required this.trainerUnlinking,
  });

  factory TrainerFeatures.fromJson(Map<String, dynamic> json) {
    return TrainerFeatures(
      trainerLinking: json['trainerLinking'] as bool? ?? true,
      trainerDiscovery: json['trainerDiscovery'] as bool? ?? true,
      trainerProfiles: json['trainerProfiles'] as bool? ?? true,
      trainerUnlinking: json['trainerUnlinking'] as bool? ?? true,
    );
  }
}

class WorkoutFeatures {
  final bool workoutProgress;
  final bool exerciseLibrary;
  final bool activeWorkoutLogging;
  final bool workoutManuals;
  final bool sessionLogs;

  WorkoutFeatures({
    required this.workoutProgress,
    required this.exerciseLibrary,
    required this.activeWorkoutLogging,
    required this.workoutManuals,
    required this.sessionLogs,
  });

  factory WorkoutFeatures.fromJson(Map<String, dynamic> json) {
    return WorkoutFeatures(
      workoutProgress: json['workoutProgress'] as bool? ?? true,
      exerciseLibrary: json['exerciseLibrary'] as bool? ?? true,
      activeWorkoutLogging: json['activeWorkoutLogging'] as bool? ?? true,
      workoutManuals: json['workoutManuals'] as bool? ?? true,
      sessionLogs: json['sessionLogs'] as bool? ?? true,
    );
  }
}

class BookingFeatures {
  final bool sessionScheduling;
  final bool sessionManagement;
  final bool sessionSummaries;
  final bool ratingFeedback;

  BookingFeatures({
    required this.sessionScheduling,
    required this.sessionManagement,
    required this.sessionSummaries,
    required this.ratingFeedback,
  });

  factory BookingFeatures.fromJson(Map<String, dynamic> json) {
    return BookingFeatures(
      sessionScheduling: json['sessionScheduling'] as bool? ?? true,
      sessionManagement: json['sessionManagement'] as bool? ?? true,
      sessionSummaries: json['sessionSummaries'] as bool? ?? true,
      ratingFeedback: json['ratingFeedback'] as bool? ?? true,
    );
  }
}

class FinanceFeatures {
  final bool subscriptionOffers;
  final bool payments;
  final bool paymentHistory;

  FinanceFeatures({
    required this.subscriptionOffers,
    required this.payments,
    required this.paymentHistory,
  });

  factory FinanceFeatures.fromJson(Map<String, dynamic> json) {
    return FinanceFeatures(
      subscriptionOffers: json['subscriptionOffers'] as bool? ?? true,
      payments: json['payments'] as bool? ?? true,
      paymentHistory: json['paymentHistory'] as bool? ?? true,
    );
  }
}

class SupportFeatures {
  final bool supportTickets;
  final bool faqSystem;
  final bool notifications;

  SupportFeatures({
    required this.supportTickets,
    required this.faqSystem,
    required this.notifications,
  });

  factory SupportFeatures.fromJson(Map<String, dynamic> json) {
    return SupportFeatures(
      supportTickets: json['supportTickets'] as bool? ?? true,
      faqSystem: json['faqSystem'] as bool? ?? true,
      notifications: json['notifications'] as bool? ?? true,
    );
  }
}

class ProfileFeatures {
  final bool profileCustomization;
  final bool accountPrivacy;

  ProfileFeatures({
    required this.profileCustomization,
    required this.accountPrivacy,
  });

  factory ProfileFeatures.fromJson(Map<String, dynamic> json) {
    return ProfileFeatures(
      profileCustomization: json['profileCustomization'] as bool? ?? true,
      accountPrivacy: json['accountPrivacy'] as bool? ?? true,
    );
  }
}

class HomeFeatures {
  final bool whatsapp;

  HomeFeatures({
    required this.whatsapp,
  });

  factory HomeFeatures.fromJson(Map<String, dynamic> json) {
    return HomeFeatures(
      whatsapp: json['whatsapp'] as bool? ?? true,
    );
  }
}
