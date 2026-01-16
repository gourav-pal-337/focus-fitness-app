import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class ManageSubscriptionButton extends StatelessWidget {
  const ManageSubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your next billing date: Dec 15, 2025',
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),
          CustomButton(
            text: 'Manage Subscription',
            type: ButtonType.filled,
            onPressed: () {
              // TODO: Handle manage subscription
            },
            width: double.infinity,
            backgroundColor: AppColors.primary,
            textColor: AppColors.background,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}

