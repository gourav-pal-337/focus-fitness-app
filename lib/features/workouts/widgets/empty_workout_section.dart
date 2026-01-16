import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class EmptyWorkoutSection extends StatelessWidget {
  const EmptyWorkoutSection({
    super.key,
    required this.onCreateTap,
    required this.onViewLogTap,
  });

  final VoidCallback onCreateTap;
  final VoidCallback onViewLogTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Empty Workout',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Start a workout from scratch',
            style: AppTextStyle.text12Medium.copyWith(
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CustomButton(
                text: '+ Create',
                type: ButtonType.filled,
                onPressed: onCreateTap,
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
                borderRadius: 12.r,

              ),
              SizedBox(width: AppSpacing.md),
              GestureDetector(
                onTap: onViewLogTap,
                child: Text(
                  'View Workout Log',
                  style: AppTextStyle.text14Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

