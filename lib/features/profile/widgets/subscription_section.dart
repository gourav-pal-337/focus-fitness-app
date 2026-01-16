import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_action_card.dart';
import 'profile_detail_card.dart';

class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({
    super.key,
    required this.plan,
    required this.nextBilling,
    required this.onManagePlans,
  });

  final String plan;
  final String nextBilling;
  final VoidCallback onManagePlans;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        ProfileActionCard(
          items: [
            ProfileDetailItem(
              label: 'Plan',
              value: plan,
            ),
            ProfileDetailItem(
              label: 'Next Billing',
              value: nextBilling,
            ),
          ],
          actionLabel: 'Manage Plans',
          actionIcon: Icons.edit_outlined,
          onAction: onManagePlans,
        ),
      ],
    );
  }
}

