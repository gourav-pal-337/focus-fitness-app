import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/session_popup/session_popup_widget.dart';
import 'core/constants/global_keys.dart';
import 'routes/app_router.dart';

import 'package:provider/provider.dart';
import 'core/provider/user_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Sync timezone on app resume
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isAuthenticated) {
        userProvider.syncTimezone();
      }
    }
  }

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
            const SessionPopupWidget(),
          ],
        );
      },
    );
  }
}
