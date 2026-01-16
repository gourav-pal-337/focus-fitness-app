import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/dashboard_bottom_navigation.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final currentIndex = navigationShell.currentIndex;

    // Sync provider with navigation shell index
    if (provider.selectedIndex != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.setSelectedIndex(currentIndex);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: DashboardBottomNavigation(
        selectedIndex: currentIndex,
        onTap: (index) {
          provider.setSelectedIndex(index);
          navigationShell.goBranch(
            index,
            // If the branch is already active, don't rebuild
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

