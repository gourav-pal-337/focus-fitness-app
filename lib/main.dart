import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:focus_fitness/core/provider/app_features_provider.dart';
import 'package:focus_fitness/core/provider/session_popup_provider.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/core/service/local_storage_service.dart';
import 'package:focus_fitness/core/service/internet_connectivity_service.dart';
import 'package:focus_fitness/features/authentication/provider/auth_provider.dart';
import 'package:focus_fitness/features/authentication/provider/forgot_password_provider.dart';
import 'package:focus_fitness/features/profile/provider/account_details_provider.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:focus_fitness/features/session/provider/session_details_provider.dart';
import 'package:focus_fitness/features/session/provider/session_history_provider.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
import 'package:focus_fitness/features/trainer/provider/payment_method_provider.dart';
import 'package:focus_fitness/features/trainer/provider/trainer_profile_provider.dart';
import 'package:focus_fitness/features/trainer/provider/system_settings_provider.dart';
import 'package:focus_fitness/features/workouts/providers/workout_provider.dart';
import 'package:focus_fitness/features/home/provider/notification_provider.dart';
import 'package:focus_fitness/firebase_options.dart';
import 'package:focus_fitness/core/responsive/responsive_config.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/sample/provider/sample_provider.dart';
import 'core/service/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  try {
    final dynamic timeZoneResult = await FlutterTimezone.getLocalTimezone();
    String locationName;

    if (timeZoneResult is String) {
      locationName = timeZoneResult;
    } else {
      // Extract from the TimezoneInfo object (ID is usually the first part)
      final String raw = timeZoneResult.toString();
      if (raw.contains('(') && raw.startsWith('TimezoneInfo')) {
        locationName = raw.split('(')[1].split(',')[0].trim();
      } else {
        locationName = raw;
      }
    }
    tz.setLocalLocation(tz.getLocation(locationName));
  } catch (e) {
    print('Could not set local timezone: $e. Falling back to UTC.');
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  // TODO: Add your actual Stripe publishable key here
  // Stripe.publishableKey = 'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY';

  await LocalStorageService.init();
  InternetConnectivityService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // fix the oriantation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Request permission
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Initialize Local Notifications
  await NotificationService().init();

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint("Got a message whilst in the foreground!");
    debugPrint("Message data: ${message.data}");

    if (message.notification != null) {
      debugPrint(
        "Message also contained a notification: ${message.notification?.body} | title : ${message.notification?.title}",
      );
      NotificationService().showNotification(message);
    }
  });

  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit derives its scale from the real device size. We read that
    // real size (MediaQuery.fromView does not cap it — it just makes this
    // rebuild on size changes) and pass a computed designSize that clamps the
    // tablet/iPad scale factor while leaving phones to scale normally.
    return MediaQuery.fromView(
      view: View.of(context),
      child: Builder(
        builder: (context) {
          final designSize = ResponsiveConfig.designSizeFor(
            MediaQuery.sizeOf(context),
          );
          return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: true,
            builder: (context, child) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<UserProvider>(
                    create: (_) => UserProvider(),
                  ),
                  ChangeNotifierProvider<AuthProvider>(
                    create: (_) => AuthProvider(),
                  ),
                  ChangeNotifierProvider<ForgotPasswordProvider>(
                    create: (_) => ForgotPasswordProvider(),
                  ),
                  ChangeNotifierProvider<SampleProvider>(
                    create: (_) => SampleProvider(),
                  ),
                  ChangeNotifierProvider<SessionPopupProvider>(
                    create: (_) => SessionPopupProvider(),
                  ),
                  ChangeNotifierProvider<LinkedTrainerProvider>(
                    create: (_) => LinkedTrainerProvider(),
                  ),
                  ChangeNotifierProvider<ClientProfileProvider>(
                    create: (_) => ClientProfileProvider(),
                  ),
                  ChangeNotifierProvider<TrainerProfileProvider>(
                    create: (_) => TrainerProfileProvider(),
                  ),
                  ChangeNotifierProvider<AccountDetailsProvider>(
                    create: (_) => AccountDetailsProvider(),
                  ),
                  ChangeNotifierProvider<SessionHistoryProvider>(
                    create: (_) => SessionHistoryProvider(),
                  ),
                  ChangeNotifierProvider<SystemSettingsProvider>(
                    create: (_) => SystemSettingsProvider(),
                  ),
                  ChangeNotifierProvider<PaymentMethodProvider>(
                    create: (_) => PaymentMethodProvider(),
                  ),
                  ChangeNotifierProvider<SessionDetailsProvider>(
                    create: (_) => SessionDetailsProvider(),
                  ),
                  ChangeNotifierProvider<AppFeaturesProvider>(
                    create: (_) => AppFeaturesProvider()..fetchFeatures(),
                    lazy: false,
                  ),
                  ChangeNotifierProvider<WorkoutProvider>(
                    create: (_) => WorkoutProvider(),
                  ),
                  ChangeNotifierProvider<NotificationProvider>(
                    create: (_) => NotificationProvider(),
                  ),
                ],
                child: const App(),
              );
            },
          );
        },
      ),
    );
  }
}
