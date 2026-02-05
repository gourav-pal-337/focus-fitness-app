import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/session_history_provider.dart';

class SessionTabBar extends StatelessWidget {
  const SessionTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionHistoryProvider>();
    final selectedTab = provider.selectedTab;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'All',
            isSelected: selectedTab == SessionTab.all,
            onTap: () {
              context.read<SessionHistoryProvider>().selectTab(SessionTab.all);
            },
          ),
          SizedBox(width: AppSpacing.sm),
          _TabButton(
            label: 'Upcoming',
            isSelected: selectedTab == SessionTab.upcoming,
            onTap: () {
              context.read<SessionHistoryProvider>().selectTab(
                SessionTab.upcoming,
              );
            },
          ),
          SizedBox(width: AppSpacing.sm),
          _TabButton(
            label: 'Past',
            isSelected: selectedTab == SessionTab.past,
            onTap: () {
              context.read<SessionHistoryProvider>().selectTab(SessionTab.past);
            },
          ),
          SizedBox(width: AppSpacing.sm),
          _TabButton(
            label: 'Cancelled',
            isSelected: selectedTab == SessionTab.cancelled,
            onTap: () {
              context.read<SessionHistoryProvider>().selectTab(
                SessionTab.cancelled,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: AppRadius.small,
        ),
        child: Text(
          label,
          style: AppTextStyle.text14Regular.copyWith(
            color: isSelected ? AppColors.background : AppColors.grey400,
          ),
        ),
      ),
    );
  }
}
