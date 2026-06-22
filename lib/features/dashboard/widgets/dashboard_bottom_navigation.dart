import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/provider/app_features_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final features = context.watch<AppFeaturesProvider>().features;

    // Hide a tab entirely when none of its features are enabled. Default to
    // showing if config isn't loaded yet (it's loaded synchronously, so this
    // is just a safety fallback). Branch indices are preserved.
    final showWorkouts =
        features == null ||
        (features.workouts.workoutProgress ||
            features.workouts.exerciseLibrary ||
            features.workouts.activeWorkoutLogging ||
            features.workouts.workoutManuals ||
            features.workouts.sessionLogs);
    final showSubscriptions =
        features == null ||
        (features.finance.subscriptionOffers ||
            features.finance.payments ||
            features.finance.paymentHistory);
    final showHistory =
        features == null ||
        (features.bookings.sessionManagement ||
            features.bookings.sessionSummaries ||
            features.bookings.ratingFeedback);
    // Privacy Policy & Terms of Use remain reachable from Profile, so the
    // Support tab can be hidden when no support feature is enabled.
    final showSupport =
        features == null ||
        (features.support.supportTickets ||
            features.support.faqSystem ||
            features.support.notifications);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1.h, color: AppColors.grey200),
          SafeArea(
            child: Container(
              height: 70.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    iconPath: AppAssets.home,
                    label: 'Home',
                    index: 0,
                    selectedIndex: selectedIndex,
                    onTap: onTap,
                  ),
                  if (showWorkouts)
                    _NavItem(
                      iconPath: AppAssets.workouts,
                      label: 'Workouts',
                      index: 1,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                  if (showSubscriptions)
                    _NavItem(
                      iconPath: AppAssets.subscriptions,
                      label: 'Subscriptions',
                      index: 2,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                  if (showSupport)
                    _NavItem(
                      iconPath: AppAssets.support,
                      label: 'Support',
                      index: 3,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                  if (showHistory)
                    _NavItem(
                      iconPath: AppAssets.sessionHistory,
                      label: 'History',
                      index: 4,
                      selectedIndex: selectedIndex,
                      onTap: onTap,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  bool get isSelected => index == selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.textPrimary : AppColors.grey400,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 2.h),
            if (isSelected)
              FittedBox(
                child: Text(
                  label,
                  style: AppTextStyle.text12Regular.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.grey400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
