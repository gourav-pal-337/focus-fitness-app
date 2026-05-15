import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/provider/app_features_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class EmptyWorkoutSection extends StatelessWidget {
  const EmptyWorkoutSection({
    super.key,

    required this.onCreateTap,
    required this.onViewLogTap,
    required this.hasData,
  });

  final VoidCallback onCreateTap;
  final VoidCallback onViewLogTap;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasData ? 'Today\'s Workout' : 'No workout for this date',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            hasData ?  "Start a workout from scratch"  :'Your trainer will assign workouts for you here',
            style: AppTextStyle.text12Medium.copyWith(
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (context.watch<AppFeaturesProvider>().isWorkoutLoggingEnabled)
                CustomButton(
                  text: 'Add Logs +',
                  type: ButtonType.filled,
                  onPressed: onCreateTap,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.background,
                  borderRadius: 12.r,
                ),
              if (context.watch<AppFeaturesProvider>().isWorkoutLoggingEnabled &&
                  context.watch<AppFeaturesProvider>().isSessionLogsEnabled)
                SizedBox(width: AppSpacing.md),
              if (context.watch<AppFeaturesProvider>().isSessionLogsEnabled)
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

