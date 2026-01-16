import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SubscriptionPlanHeader extends StatelessWidget {
  const SubscriptionPlanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'SUBSCRIPTION PLAN',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Your active membership details',
          style: AppTextStyle.text12Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }
}

