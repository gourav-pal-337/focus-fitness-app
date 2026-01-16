import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/session_popup_provider.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/core/service/local_storage_service.dart';
import 'package:focus_fitness/features/authentication/provider/auth_provider.dart';
import 'package:focus_fitness/features/authentication/provider/forgot_password_provider.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/sample/provider/sample_provider.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
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
          ],
          child: const App(),
        );
      },
    );
  }
}


