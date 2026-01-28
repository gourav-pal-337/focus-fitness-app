import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_redirect.dart';
import '../features/authentication/ui/enter_name_screen.dart';
import '../features/authentication/ui/linktrainer/enter_trainer_id.dart';
import '../features/authentication/ui/linktrainer/link_trainer_screen.dart';
import '../features/authentication/ui/auth/auth_mode.dart';
import '../features/authentication/ui/auth/auth_with_email_screen.dart';
import '../features/authentication/ui/auth/auth_with_phone_screen.dart';
import '../features/authentication/ui/auth/auth_otp_verification_screen.dart';
import '../features/authentication/ui/forgot_password/check_email_screen.dart';
import '../features/authentication/ui/forgot_password/forgot_password_screen.dart';
import '../features/authentication/ui/forgot_password/set_new_password_screen.dart';
import '../features/dashboard/provider/dashboard_provider.dart';
import '../features/dashboard/ui/dashboard_shell.dart';
import '../features/home/ui/home_screen.dart';
import '../features/home/ui/notifications_screen.dart';
import '../features/trainer/ui/trainer_profile_screen.dart';
import '../features/trainer/ui/payment_method_screen.dart';
import '../features/trainer/ui/transaction_successful_screen.dart';
import '../features/trainer/ui/delink_trainer_screen.dart';
import '../features/trainer/ui/delink_trainer_success_screen.dart';
import '../features/session/ui/session_history_screen.dart';
import '../features/session/ui/session_details_screen.dart';
import '../features/session/ui/feedback_success_screen.dart';
import '../features/session/widgets/session_card.dart';
import '../features/workouts/ui/workouts_screen.dart';
import '../features/workouts/ui/exercises_screen.dart';
import '../features/workouts/ui/exercise_details_screen.dart';
import '../features/workouts/ui/workout_progress_screen.dart';
import '../features/workouts/ui/edit_exercise_set_screen.dart';
import '../features/workouts/ui/session_log_screen.dart';
import '../features/workouts/ui/session_log_details_screen.dart';
import '../features/workouts/provider/workout_provider.dart';
import '../features/video_player/ui/video_player_screen.dart';
import '../features/subscriptions/ui/subscriptions_screen.dart';
import '../features/subscriptions/ui/past_subscriptions_screen.dart';
import '../features/subscriptions/ui/subscription_details_screen.dart';
import '../features/support/ui/support_screen.dart';
import '../features/support/ui/contact_support_screen.dart';
import '../features/support/ui/ticket_details_screen.dart';
import '../features/support/ui/chat_support_screen.dart';
import '../features/support/ui/ticket_success_screen.dart';
import '../features/profile/ui/profile_screen.dart';
import '../features/profile/ui/edit_profile_details_screen.dart';
import '../features/profile/provider/edit_profile_details_provider.dart';
import '../features/profile/provider/client_profile_provider.dart';
import '../features/profile/ui/account_details_screen.dart';
import '../features/profile/ui/change_password_screen.dart';
import '../features/profile/ui/privacy_security_screen.dart';
import '../features/profile/ui/two_factor_authentication_screen.dart';
import '../features/profile/ui/delete_account_screen.dart';
import '../features/onboarding/provider/onboarding_provider.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/sample/ui/sample_screen.dart';
import '../features/splash/ui/splash_screen.dart';

abstract class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: SplashRoute.path,
    redirect: appRedirect,
    routes: <RouteBase>[
      SplashRoute.route,
      EnterNameRoute.route,
      LoginWithEmailRoute.route,
      SignupWithEmailRoute.route,
      LoginWithPhoneRoute.route,
      SignupWithPhoneRoute.route,
      OtpVerificationRoute.route,
      ForgotPasswordRoute.route,
      CheckEmailRoute.route,
      SetNewPasswordRoute.route,
      EnterTrainerIdRoute.route,
      LinkTrainerRoute.route,
      OnboardingRoute.route,
      DashboardRoute.route,
      NotificationsRoute.route,
      TrainerProfileRoute.route,
      PaymentMethodRoute.route,
      TransactionSuccessfulRoute.route,
      DelinkTrainerRoute.route,
      DelinkTrainerSuccessRoute.route,
      SessionHistoryRoute.route,
      SessionDetailsRoute.route,
      FeedbackSuccessRoute.route,
      PastSubscriptionsRoute.route,
      SubscriptionDetailsRoute.route,
      ExercisesRoute.route,
      ExerciseDetailsRoute.route,
      WorkoutProgressRoute.route,
      EditExerciseSetRoute.route,
      SessionLogRoute.route,
      SessionLogDetailsRoute.route,
      VideoPlayerRoute.route,
      EditProfileDetailsRoute.route,
      AccountDetailsRoute.route,
      ChangePasswordRoute.route,
      PrivacySecurityRoute.route,
      TwoFactorAuthenticationRoute.route,
      DeleteAccountRoute.route,
      SampleRoute.route,
      ContactSupportRoute.route,
      TicketDetailsRoute.route,
      ChatSupportRoute.route,
      TicketSuccessRoute.route,
    ],
  );
}

abstract class SplashRoute {
  static const String path = '/';

  static final GoRoute route = GoRoute(
    path: path,
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  );
}

abstract class OnboardingRoute {
  static const String path = '/onboarding';

  static final GoRoute route = GoRoute(
    path: path,
    name: 'onboarding',
    builder: (context, state) {
      return ChangeNotifierProvider<OnboardingProvider>(
        create: (_) => OnboardingProvider(),
        child: const OnboardingScreen(),
      );
    },
  );
}

abstract class EnterNameRoute {
  static const String path = '/enter-name';
  static const String name = 'enterName';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const EnterNameScreen(),
  );
}

abstract class LoginWithEmailRoute {
  static const String path = '/login-email';
  static const String name = 'loginEmail';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        const AuthWithEmailScreen(mode: AuthMode.login),
  );
}

abstract class SignupWithEmailRoute {
  static const String path = '/signup-email';
  static const String name = 'signupEmail';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        const AuthWithEmailScreen(mode: AuthMode.signup),
  );
}

abstract class ForgotPasswordRoute {
  static const String path = '/forgot-password';
  static const String name = 'forgotPassword';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const ForgotPasswordScreen(),
  );
}

abstract class CheckEmailRoute {
  static const String path = '/check-email/:email';
  static const String name = 'checkEmail';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final email = state.pathParameters['email'] ?? '';
      return CheckEmailScreen(email: email);
    },
  );
}

abstract class SetNewPasswordRoute {
  static const String path = '/set-new-password';
  static const String name = 'setNewPassword';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const SetNewPasswordScreen(),
  );
}

abstract class LoginWithPhoneRoute {
  static const String path = '/login-phone';
  static const String name = 'loginPhone';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        const AuthWithPhoneScreen(mode: AuthMode.login),
  );
}

abstract class SignupWithPhoneRoute {
  static const String path = '/signup-phone';
  static const String name = 'signupPhone';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        const AuthWithPhoneScreen(mode: AuthMode.signup),
  );
}

abstract class OtpVerificationRoute {
  static const String path = '/otp-verification/:mobileNumber';
  static const String name = 'otpVerification';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final mobileNumber = state.pathParameters['mobileNumber'] ?? '';
      final modeParam = state.uri.queryParameters['mode'] ?? 'signup';
      final mode = modeParam == 'login' ? AuthMode.login : AuthMode.signup;
      return AuthOtpVerificationScreen(mobileNumber: mobileNumber, mode: mode);
    },
  );
}

abstract class EnterTrainerIdRoute {
  static const String path = '/enter-trainer-id';
  static const String name = 'enterTrainerId';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const EnterTrainerIdScreen(),
  );
}

abstract class LinkTrainerRoute {
  static const String path = '/link-trainer/:trainerId';
  static const String name = 'linkTrainer';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final trainerId = state.pathParameters['trainerId'] ?? '';
      return LinkTrainerScreen(trainerId: trainerId);
    },
  );
}

abstract class DashboardRoute {
  static const String path = '/dashboard';

  static final StatefulShellRoute route = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ChangeNotifierProvider<DashboardProvider>(
        create: (_) => DashboardProvider(),
        child: DashboardShell(navigationShell: navigationShell),
      );
    },
    branches: [
      StatefulShellBranch(routes: [HomeRoute.route]),
      StatefulShellBranch(routes: [WorkoutsRoute.route]),
      StatefulShellBranch(routes: [SubscriptionsRoute.route]),
      StatefulShellBranch(routes: [SupportRoute.route]),
      StatefulShellBranch(routes: [ProfileRoute.route]),
    ],
  );
}

abstract class HomeRoute {
  static const String path = '/dashboard/home';
  static const String name = 'home';

  static final GoRoute route = GoRoute(
    path: '/dashboard/home',
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: const HomeScreen()),
  );
}

abstract class WorkoutsRoute {
  static const String path = '/dashboard/workouts';
  static const String name = 'workouts';

  static final GoRoute route = GoRoute(
    path: '/dashboard/workouts',
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: const WorkoutsScreen()),
  );
}

abstract class SubscriptionsRoute {
  static const String path = '/dashboard/subscriptions';
  static const String name = 'subscriptions';

  static final GoRoute route = GoRoute(
    path: '/dashboard/subscriptions',
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: const SubscriptionsScreen()),
  );
}

abstract class SupportRoute {
  static const String path = '/dashboard/support';
  static const String name = 'support';

  static final GoRoute route = GoRoute(
    path: '/dashboard/support',
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: const SupportScreen()),
  );
}

abstract class ContactSupportRoute {
  static const String path = '/dashboard/contact-support';
  static const String name = 'contactSupport';

  static final GoRoute route = GoRoute(
    path: '/dashboard/contact-support',
    name: name,
    builder: (context, state) => const ContactSupportScreen(),
  );
}

abstract class TicketDetailsRoute {
  static const String path = '/dashboard/ticket-details';
  static const String name = 'ticketDetails';

  static final GoRoute route = GoRoute(
    path: '/dashboard/ticket-details',
    name: name,
    builder: (context, state) => const TicketDetailsScreen(),
  );
}

abstract class ChatSupportRoute {
  static const String path = '/dashboard/chat-support';
  static const String name = 'chatSupport';

  static final GoRoute route = GoRoute(
    path: '/dashboard/chat-support',
    name: name,
    builder: (context, state) => const ChatSupportScreen(),
  );
}

abstract class TicketSuccessRoute {
  static const String path = '/dashboard/ticket-success';
  static const String name = 'ticketSuccess';

  static final GoRoute route = GoRoute(
    path: '/dashboard/ticket-success',
    name: name,
    builder: (context, state) {
      final ticketId = state.uri.queryParameters['ticketId'];
      return TicketSuccessScreen(ticketId: ticketId);
    },
  );
}

abstract class ProfileRoute {
  static const String path = '/dashboard/profile';
  static const String name = 'profile';

  static final GoRoute route = GoRoute(
    path: '/dashboard/profile',
    name: name,
    pageBuilder: (context, state) =>
        NoTransitionPage(child: const ProfileScreen()),
  );
}

abstract class EditProfileDetailsRoute {
  static const String path = '/edit-profile-details';
  static const String name = 'editProfileDetails';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final title = state.uri.queryParameters['title'] ?? 'Edit Details';

      // Get profile data from provider
      final profileProvider = Provider.of<ClientProfileProvider>(
        context,
        listen: false,
      );
      final profile = profileProvider.profile;

      // Default fields based on title
      List<EditField> fields;
      EditProfileSection section;
      if (title == 'Personal Details') {
        section = EditProfileSection.personalDetails;
        fields = [
          EditField(
            label: 'DOB',
            value: profile?.dateOfBirth ?? '',
            hintText: 'Select date of birth',
            isDateField: true,
          ),
          EditField(
            label: 'Height',
            value: (profile?.height ?? '').toString(),
            hintText: 'Enter height in cm',
          ),
          EditField(
            label: 'Weight',
            value: (profile?.weight ?? '').toString(),
            hintText: 'Enter weight in kg',
          ),
          EditField(
            label: 'Fitness Level',
            value: (profile?.fitnessLevel ?? '').toString(),
            hintText: 'e.g., Beginner, Intermediate, Advanced',
          ),
        ];
      } else if (title == 'Fitness Goals') {
        section = EditProfileSection.fitnessGoals;
        fields = [
          EditField(
            label: 'Weight Goal',
            value: profile?.weightGoal ?? '',
            hintText: 'e.g., 72-74kg',
          ),
          EditField(
            label: 'Body Type',
            value: profile?.bodyType ?? '',
            hintText: 'e.g., Muscular, Lean',
          ),
          EditField(
            label: 'Performance Goal',
            value: profile?.performanceGoal ?? '',
            hintText: 'e.g., Improve Stamina',
          ),
        ];
      } else {
        section = EditProfileSection.personalDetails;
        fields = const [];
      }

      return EditProfileDetailsScreen(
        title: title,
        fields: fields,
        section: section,
      );
    },
  );
}

abstract class AccountDetailsRoute {
  static const String path = '/account-details';
  static const String name = 'accountDetails';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AccountDetailsScreen(),
  );
}

abstract class ChangePasswordRoute {
  static const String path = '/change-password';
  static const String name = 'changePassword';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const ChangePasswordScreen(),
  );
}

abstract class PrivacySecurityRoute {
  static const String path = '/privacy-security';
  static const String name = 'privacySecurity';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const PrivacySecurityScreen(),
  );
}

abstract class TwoFactorAuthenticationRoute {
  static const String path = '/two-factor-authentication';
  static const String name = 'twoFactorAuthentication';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const TwoFactorAuthenticationScreen(),
  );
}

abstract class DeleteAccountRoute {
  static const String path = '/delete-account';
  static const String name = 'deleteAccount';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const DeleteAccountScreen(),
  );
}

abstract class NotificationsRoute {
  static const String path = '/notifications';
  static const String name = 'notifications';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const NotificationsScreen(),
  );
}

abstract class TrainerProfileRoute {
  static const String path = '/trainer/:trainerId';
  static const String name = 'trainerProfile';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final trainerId = state.pathParameters['trainerId'] ?? '';
      return TrainerProfileScreen(trainerId: trainerId);
    },
  );
}

abstract class PaymentMethodRoute {
  static const String path = '/payment-method';
  static const String name = 'paymentMethod';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final amountParam = state.uri.queryParameters['amount'];
      final amount = amountParam != null
          ? double.tryParse(amountParam) ?? 100.00
          : 100.00;

      // Booking data
      final trainerId = state.uri.queryParameters['trainerId'] ?? '';
      final sessionPlanId = state.uri.queryParameters['sessionPlanId'] ?? '';
      final dateId = state.uri.queryParameters['dateId'] ?? '';
      final timeSlot = state.uri.queryParameters['timeSlot'] ?? '';
      final durationMinutesParam = state.uri.queryParameters['durationMinutes'];
      final durationMinutes = durationMinutesParam != null
          ? int.tryParse(durationMinutesParam) ?? 60
          : 60;

      // Reconstruct available dates from dateId (we only need the selected date)
      List<Map<String, dynamic>> availableDates = [];
      if (dateId.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(dateId);
          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          availableDates = [
            {
              'dateId': dateId,
              'day': days[dateTime.weekday - 1],
              'sessionPlanId': sessionPlanId,
            },
          ];
        } catch (e) {
          // If parsing fails, use empty list
          availableDates = [];
        }
      }

      return PaymentMethodScreen(
        amount: amount,
        trainerId: trainerId,
        sessionPlanId: sessionPlanId,
        dateId: dateId,
        timeSlot: timeSlot,
        durationMinutes: durationMinutes,
        availableDates: availableDates,
      );
    },
  );
}

abstract class DelinkTrainerRoute {
  static const String path = '/dashboard/delink-trainer';
  static const String name = 'delinkTrainer';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const DelinkTrainerScreen(),
  );
}

abstract class DelinkTrainerSuccessRoute {
  static const String path = '/dashboard/delink-trainer-success';
  static const String name = 'delinkTrainerSuccess';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const DelinkTrainerSuccessScreen(),
  );
}

abstract class TransactionSuccessfulRoute {
  static const String path = '/transaction-successful';
  static const String name = 'transactionSuccessful';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final amountParam = state.uri.queryParameters['amount'];
      final amount = amountParam != null
          ? double.tryParse(amountParam) ?? 100.00
          : 100.00;
      final paymentMethod =
          state.uri.queryParameters['paymentMethod'] ?? 'Standard Charted Card';
      final cardNumber =
          state.uri.queryParameters['cardNumber'] ?? '1234 5678 2345';
      final bookingId = state.uri.queryParameters['bookingId'];
      final trainerName = state.uri.queryParameters['trainerName'];
      final sessionDate = state.uri.queryParameters['sessionDate'];
      final sessionTime = state.uri.queryParameters['sessionTime'];
      final startTimeIso = state.uri.queryParameters['sessionStartTime'];
      final sessionStartTime = startTimeIso != null
          ? DateTime.tryParse(startTimeIso)
          : null;

      return TransactionSuccessfulScreen(
        amount: amount,
        paymentMethod: paymentMethod,
        cardNumber: cardNumber,
        trainerName: trainerName,
        bookingId: bookingId,
        sessionDate: sessionDate,
        sessionTime: sessionTime,
        sessionStartTime: sessionStartTime,
      );
    },
  );
}

abstract class SessionHistoryRoute {
  static const String path = '/session-history';
  static const String name = 'sessionHistory';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const SessionHistoryScreen(),
  );
}

abstract class FeedbackSuccessRoute {
  static const String path = '/feedback-success';
  static const String name = 'feedbackSuccess';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const FeedbackSuccessScreen(),
  );
}

abstract class SessionDetailsRoute {
  static const String path = '/session-details';
  static const String name = 'sessionDetails';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final session = state.extra as SessionData;
      // final trainerName = state.uri.queryParameters['trainerName'] ?? '';
      // final trainerImageUrl =
      //     state.uri.queryParameters['trainerImageUrl'] ?? '';
      // final sessionType = state.uri.queryParameters['sessionType'] ?? '';
      // final duration = state.uri.queryParameters['duration'] ?? '';
      // final statusParam = state.uri.queryParameters['status'] ?? 'completed';
      // final date = state.uri.queryParameters['date'] ?? '';

      // final status = statusParam == 'completed'
      //     ? SessionStatus.completed
      //     : statusParam == 'cancelled'
      //     ? SessionStatus.cancelled
      //     : SessionStatus.upcoming;

      // final bookingId = state.uri.queryParameters['bookingId'];

      // final session = SessionData(
      //   trainerName: trainerName,
      //   trainerImageUrl: trainerImageUrl,
      //   sessionType: sessionType,
      //   duration: duration,
      //   status: status,
      //   date: date,
      //   bookingId: bookingId,
      // );

      return SessionDetailsScreen(session: session);
    },
  );
}

abstract class PastSubscriptionsRoute {
  static const String path = '/past-subscriptions';
  static const String name = 'pastSubscriptions';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const PastSubscriptionsScreen(),
  );
}

abstract class SubscriptionDetailsRoute {
  static const String path = '/subscription-details';
  static const String name = 'subscriptionDetails';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final planName = state.uri.queryParameters['planName'] ?? '';
      final startDate = state.uri.queryParameters['startDate'] ?? '';
      final endDate = state.uri.queryParameters['endDate'] ?? '';
      final paymentMethod = state.uri.queryParameters['paymentMethod'] ?? '';

      return SubscriptionDetailsScreen(
        planName: planName,
        startDate: startDate,
        endDate: endDate,
        paymentMethod: paymentMethod,
      );
    },
  );
}

abstract class ExercisesRoute {
  static const String path = '/exercises';
  static const String name = 'exercises';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final fromWorkoutProgress =
          state.uri.queryParameters['fromWorkoutProgress'] == 'true';
      final dateMillis = state.uri.queryParameters['date'];
      final date = dateMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(dateMillis))
          : null;
      return ExercisesScreen(
        fromWorkoutProgress: fromWorkoutProgress,
        workoutDate: date,
      );
    },
  );
}

abstract class ExerciseDetailsRoute {
  static const String path = '/exercise-details';
  static const String name = 'exerciseDetails';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final exerciseId = state.uri.queryParameters['exerciseId'] ?? '1';
      return ExerciseDetailsScreen(exerciseId: exerciseId);
    },
  );
}

abstract class WorkoutProgressRoute {
  static const String path = '/workout-progress';
  static const String name = 'workoutProgress';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final exerciseId = state.uri.queryParameters['exerciseId'];
      final exerciseName = state.uri.queryParameters['exerciseName'];
      return WorkoutProgressScreen(
        exerciseIdToAdd: exerciseId,
        exerciseNameToAdd: exerciseName,
      );
    },
  );
}

abstract class SessionLogRoute {
  static const String path = '/session-log';
  static const String name = 'sessionLog';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const SessionLogScreen(),
  );
}

abstract class SessionLogDetailsRoute {
  static const String path = '/session-log-details';
  static const String name = 'sessionLogDetails';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final dateMillis = state.uri.queryParameters['date'];
      final date = dateMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(dateMillis))
          : DateTime.now();
      return SessionLogDetailsScreen(date: date);
    },
  );
}

abstract class EditExerciseSetRoute {
  static const String path = '/edit-exercise-set';
  static const String name = 'editExerciseSet';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final exerciseId = state.uri.queryParameters['exerciseId'] ?? '';
      final exerciseName = state.uri.queryParameters['exerciseName'] ?? '';
      final dateMillis = state.uri.queryParameters['date'];
      final setIndex = state.uri.queryParameters['setIndex'];

      final date = dateMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(dateMillis))
          : DateTime.now();

      return ChangeNotifierProvider.value(
        value: WorkoutProgressProvider(),
        child: _EditExerciseSetScreenWrapper(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          date: date,
          setIndex: setIndex != null ? int.parse(setIndex) : null,
        ),
      );
    },
  );
}

class _EditExerciseSetScreenWrapper extends StatelessWidget {
  const _EditExerciseSetScreenWrapper({
    required this.exerciseId,
    required this.exerciseName,
    required this.date,
    this.setIndex,
  });

  final String exerciseId;
  final String exerciseName;
  final DateTime date;
  final int? setIndex;

  @override
  Widget build(BuildContext context) {
    final provider = WorkoutProgressProvider();
    final workoutProgressList = provider.getWorkoutProgressForDate(date);
    final workoutProgress = workoutProgressList.firstWhere(
      (wp) => wp.exerciseId == exerciseId,
      orElse: () => WorkoutProgress(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        date: date,
        sets: [],
      ),
    );

    return ChangeNotifierProvider.value(
      value: provider,
      child: EditExerciseSetScreen(
        workoutProgress: workoutProgress,
        date: date,
        setIndex: setIndex,
      ),
    );
  }
}

abstract class VideoPlayerRoute {
  static const String path = '/video-player';
  static const String name = 'videoPlayer';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final videoUrl = state.uri.queryParameters['videoUrl'] ?? '';
      final title = state.uri.queryParameters['title'];
      return VideoPlayerScreen(videoUrl: videoUrl, title: title);
    },
  );
}

abstract class SampleRoute {
  static const String path = '/sample';

  static final GoRoute route = GoRoute(
    path: path,
    name: 'sample',
    builder: (context, state) => const SampleScreen(),
  );
}
