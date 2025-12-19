import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
import '../features/onboarding/provider/onboarding_provider.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/sample/ui/sample_screen.dart';
import '../features/splash/ui/splash_screen.dart';

abstract class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: SplashRoute.path,
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
      SampleRoute.route,
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
    builder: (context, state) => const AuthWithEmailScreen(
      mode: AuthMode.login,
    ),
  );
}

abstract class SignupWithEmailRoute {
  static const String path = '/signup-email';
  static const String name = 'signupEmail';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AuthWithEmailScreen(
      mode: AuthMode.signup,
    ),
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
          return CheckEmailScreen(
            email: email,
          );
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
    builder: (context, state) => const AuthWithPhoneScreen(
      mode: AuthMode.login,
    ),
  );
}

abstract class SignupWithPhoneRoute {
  static const String path = '/signup-phone';
  static const String name = 'signupPhone';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AuthWithPhoneScreen(
      mode: AuthMode.signup,
    ),
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
          return AuthOtpVerificationScreen(
            mobileNumber: mobileNumber,
            mode: mode,
          );
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
          final trainerId = state.pathParameters['trainerId'] ?? '12458';
          return LinkTrainerScreen(
            trainerId: trainerId,
          );
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

