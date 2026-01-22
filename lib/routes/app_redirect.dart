import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/provider/user_provider.dart';
import '../core/service/biometric_auth_service.dart';
import '../core/service/local_storage_service.dart';
import 'app_router.dart';

/// Redirect logic for go_router
/// Checks authentication status and redirects accordingly
Future<String?> appRedirect(BuildContext context, GoRouterState state) async {
  final isSplash = state.matchedLocation == SplashRoute.path;

  if (isSplash) {
    // Allow splash screen to render first, then schedule navigation
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));

      final token = await LocalStorageService.getToken();

      if (token == null || token.isEmpty) {
        AppRouter.router.go(OnboardingRoute.path);
      } else {
        // Check if two-factor authentication is enabled
        final isTwoFactorEnabled =
            await LocalStorageService.getTwoFactorAuthEnabled();

        if (isTwoFactorEnabled) {
          // Perform biometric authentication
          // Set biometricOnly to false to allow passcode fallback on iOS
          final biometricService = BiometricAuthService();
          final isAuthenticated = await biometricService.authenticate(
            localizedReason: 'Please authenticate to access the app',
            biometricOnly: false,
          );

          // If authentication failed or was canceled, stay on splash or navigate to onboarding
          if (!isAuthenticated) {
            // User canceled or authentication failed
            // You can choose to either stay on splash or navigate to onboarding
            // For security, we'll navigate to onboarding if auth fails
            // AppRouter.router.go(OnboardingRoute.path);
            return;
          }
        }

        // Get user details using UserProvider
        try {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );

          // Try loading from cache first
          if (await userProvider.loadUserFromCache()) {
            AppRouter.router.go(HomeRoute.path);
            // Optionally update in background
            userProvider.fetchUserDetails();
            return;
          }

          final success = await userProvider.fetchUserDetails();

          if (success) {
            // if(userProvider.user?.isTrainerLinked != true) {
            //   AppRouter.router.go(EnterTrainerIdRoute.path);
            // } else {
            AppRouter.router.go(HomeRoute.path);
            // }
          } else {
            // If token is invalid (401), clear and go to onboarding
            if (userProvider.error?.contains('401') == true ||
                userProvider.error?.toLowerCase().contains('unauthorized') ==
                    true ||
                userProvider.error?.toLowerCase().contains('session expired') ==
                    true) {
              LocalStorageService.clearAll();
              userProvider.clearUser();
              AppRouter.router.go(OnboardingRoute.path);
            } else {
              // Still navigate to home on other errors
              AppRouter.router.go(OnboardingRoute.path);
            }
          }
        } catch (e) {
          // On error, still navigate to home
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          userProvider.setError(e.toString());
          AppRouter.router.go(OnboardingRoute.path);
        }
      }
    });

    return null; // Allow splash screen to render
  }

  // For other routes, check authentication if needed
  // Add your authentication checks here for protected routes

  return null; // No redirect needed
}
