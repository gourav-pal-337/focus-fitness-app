import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/trainer_profile_provider.dart';

class SessionPlanSelector extends StatelessWidget {
  const SessionPlanSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final sessionPlans = provider.sessionPlans;

    if (sessionPlans.isEmpty) {
      return const SizedBox.shrink();
    }

    // Don't show selector if only one plan
    if (sessionPlans.length == 1) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Session Plan',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: () => _showSessionPlanDialog(context, provider),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.small,
                border: Border.all(
                  color: AppColors.grey200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.selectedSessionPlan?.title ?? 'Select session plan',
                      style: AppTextStyle.text16Regular.copyWith(
                        color: provider.selectedSessionPlan == null
                            ? AppColors.grey400
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 24.sp,
                    color: AppColors.grey400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSessionPlanDialog(
    BuildContext context,
    TrainerProfileProvider provider,
  ) {
    final sessionPlans = provider.sessionPlans;
    final selectedPlan = provider.selectedSessionPlan;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
        ),
        title: Text(
          'Select Session Plan',
          style: AppTextStyle.text18SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sessionPlans.map((plan) {
            final isSelected = selectedPlan?.id == plan.id;
            return ListTile(
              title: Text(
                plan.title,
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: plan.description != null && plan.description!.isNotEmpty
                  ? Text(
                      plan.description!,
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    )
                  : null,
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: 20.sp,
                    )
                  : null,
              onTap: () {
                provider.selectSessionPlan(plan);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

