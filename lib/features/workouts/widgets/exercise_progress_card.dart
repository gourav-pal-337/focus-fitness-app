import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../provider/workout_provider.dart';

class ExerciseProgressCard extends StatelessWidget {
  const ExerciseProgressCard({
    super.key,
    required this.workoutProgress,
    required this.onAddSet,
    required this.date,
  });

  final WorkoutProgress workoutProgress;
  final VoidCallback onAddSet;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      // padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
            // offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 11.h),
            child: Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 20.sp,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  workoutProgress.exerciseName,
                  style: AppTextStyle.text16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: AppSpacing.sm),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
            height: 0,
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  'Sets',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Reps',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Weight',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
          ),
          if (workoutProgress.sets.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Text(
                  'No sets added yet',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ),
            )
          else
            ...workoutProgress.sets.asMap().entries.map((entry) {
              final index = entry.key;
              final set = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}',
                            style: AppTextStyle.text14Medium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${set.reps}',
                            style: AppTextStyle.text14Medium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            set.weight != null ? '${set.weight}' : '-',
                            style: AppTextStyle.text14Medium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.grey200,
                    thickness: 1,
                    
                  ),
                ],
              );
            }),
          // SizedBox(height: AppSpacing.md),
        if(workoutProgress.sets.isEmpty)  Divider(
            color: AppColors.grey200,
            thickness: 1,
            height: 0,
          ),
         
          Center(
            child: CustomButton(
              margin: EdgeInsets.only(bottom: AppSpacing.xs),
              height: 40.h,
              text: 'Add New Set',
              type: ButtonType.text,
              onPressed: onAddSet,
              borderColor: AppColors.textPrimary,
              textColor: AppColors.textPrimary,
              borderRadius: 12.r,
              // padding: EdgeInsets.symmetric(
              //   horizontal: AppSpacing.lg,
              //   vertical: AppSpacing.sm,
              // ),
              textStyle: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              icon: Icon(
                Icons.add,
                size: 20.sp,
                color: AppColors.textPrimary,
              ),
              iconPosition: IconPosition.left,
            ),
          ),
        ],
      ),
    );
  }
}

