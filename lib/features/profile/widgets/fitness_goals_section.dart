import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';
import '../provider/client_profile_provider.dart';
import 'profile_detail_card.dart';

class FitnessGoalsSection extends StatelessWidget {
  const FitnessGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness Goals',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        ProfileDetailCard(
              items: [
            ProfileDetailItem(
              label: 'Weight Goal',
                  value: profile?.weightGoal,
            ),
            ProfileDetailItem(
              label: 'Body Type',
                  value: profile?.bodyType,
            ),
            ProfileDetailItem(
              label: 'Performance Goal',
                  value: profile?.performanceGoal,
            ),
          ],
          onEdit: () {
            context.push(
              '${EditProfileDetailsRoute.path}?title=Fitness Goals',
            );
          },
        ),
      ],
        );
      },
    );
  }
}

