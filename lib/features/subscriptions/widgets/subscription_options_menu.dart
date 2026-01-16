import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

enum SubscriptionMenuOption {
  viewHistory,
  cancelSubscription,
}

class SubscriptionOptionsMenu {
  static Widget buildMenuButton({
    required VoidCallback onViewHistory,
    required VoidCallback onCancelSubscription,
  }) {
    return PopupMenuButton<SubscriptionMenuOption>(
      icon: Icon(
        Icons.more_vert,
        size: 24.sp,
        color: AppColors.background,
      ),
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.extraLarge,
      ),
      elevation: 8,
      onSelected: (SubscriptionMenuOption option) {
        switch (option) {
          case SubscriptionMenuOption.viewHistory:
            onViewHistory();
            break;
          case SubscriptionMenuOption.cancelSubscription:
            onCancelSubscription();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SubscriptionMenuOption>>[
        PopupMenuItem<SubscriptionMenuOption>(
          value: SubscriptionMenuOption.viewHistory,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
            // vertical: AppSpacing.lg,
          ),
          child: Text(
            'View History',
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        PopupMenuDivider(
          height: 1,
        ),
        PopupMenuItem<SubscriptionMenuOption>(
          value: SubscriptionMenuOption.cancelSubscription,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
            // vertical: AppSpacing.lg,
          ),
          child: Text(
            'Cancel Subscription',
            style: AppTextStyle.text14Regular.copyWith(
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

