import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/session_popup/session_popup_widget.dart';
import 'core/constants/global_keys.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Focus Fitness',
      theme: AppTheme.light,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            // Global session popup overlay
            SessionPopupWidget(),
          ],
        );
      },
    );
  }
}
