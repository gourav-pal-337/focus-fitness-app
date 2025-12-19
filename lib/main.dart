import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/features/authentication/provider/auth_provider.dart';
import 'package:focus_fitness/features/authentication/provider/forgot_password_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/sample/provider/sample_provider.dart';

void main() {
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
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(),
            ),
            ChangeNotifierProvider<ForgotPasswordProvider>(
              create: (_) => ForgotPasswordProvider(),
            ),
            ChangeNotifierProvider<SampleProvider>(
              create: (_) => SampleProvider(),
            ),
          ],
          child: const App(),
        );
      },
    );
  }
}


