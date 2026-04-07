import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/exercise_model.dart';

class ExerciseOverviewSection extends StatelessWidget {
  const ExerciseOverviewSection({super.key, required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context) {
    print('check data ::: ${exercise.calories} : ${exercise.averageMinutes}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricsRow(
          level: exercise.level,
          averageMinutes: exercise.averageMinutes,
          intensity: exercise.intensity,
        ),
        if (exercise.category != null && exercise.category!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.lg),
          // Text(
          //   'Category',
          //   style: AppTextStyle.text14SemiBold.copyWith(
          //     color: AppColors.textPrimary,
          //   ),
          // ),
          SizedBox(height: AppSpacing.xs),
          Text(
            exercise.category!,
            style: AppTextStyle.text14SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (exercise.categoryDescription != null &&
              exercise.categoryDescription!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              exercise.categoryDescription!,
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey400,
                height: 1.5,
              ),
            ),
          ],
          // SizedBox(height: AppSpacing.lg),
        ],
        SizedBox(height: AppSpacing.lg),
        Text(
          exercise.description,
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.grey400,
            height: 1.5,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        _PlanRow(
          sets: exercise.planSets,
          reps: exercise.planReps,
          restTime: exercise.restTime,
        ),
        SizedBox(height: AppSpacing.lg),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Calories:  ',
                style: AppTextStyle.text14SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              TextSpan(
                text: '${exercise.calories} cal',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ),
        if (exercise.instructions != null &&
            exercise.instructions!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xl),
          Text(
            'Instructions',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            exercise.instructions!,
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.grey400,
              height: 1.5,
            ),
          ),
        ],
        if (exercise.tips != null && exercise.tips!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xl),
          Text(
            'Tips',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            exercise.tips!,
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.grey400,
              height: 1.5,
            ),
          ),
        ],
        if (exercise.commonMistakes != null &&
            exercise.commonMistakes!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xl),
          Text(
            'Common Mistakes',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            exercise.commonMistakes!,
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.grey400,
              height: 1.5,
            ),
          ),
        ],
        SizedBox(height: AppSpacing.lg),
        Text(
          'Good For',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          exercise.goodFor.isEmpty ? '-' : exercise.goodFor.join(', '),
          style: AppTextStyle.text14Regular.copyWith(
            color: exercise.goodFor.isEmpty
                ? AppColors.grey400
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({
    required this.level,
    required this.averageMinutes,
    required this.intensity,
  });

  final String level;
  final int averageMinutes;
  final String intensity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _MetricItem(
            crossAxisAlignment: CrossAxisAlignment.start,
            label: 'Level',
            value: level,
          ),
        ),
        Expanded(
          child: _MetricItem(
            crossAxisAlignment: CrossAxisAlignment.center,
            label: 'Average',
            value: '$averageMinutes Minutes',
          ),
        ),
        Expanded(
          child: _MetricItem(
            crossAxisAlignment: CrossAxisAlignment.end,
            label: 'Intensity',
            value: intensity,
          ),
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.crossAxisAlignment,
    required this.label,
    required this.value,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: AppTextStyle.text12Regular.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyle.text14SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({this.sets, this.reps, this.restTime});

  final int? sets;
  final String? reps;
  final int? restTime;

  @override
  Widget build(BuildContext context) {
    if (sets == null && reps == null && restTime == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Plan',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (sets != null)
              Expanded(
                child: _MetricItem(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  label: 'Sets',
                  value: '$sets',
                ),
              ),
            if (reps != null)
              Expanded(
                child: _MetricItem(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  label: 'Reps',
                  value: reps!,
                ),
              ),
            if (restTime != null)
              Expanded(
                child: _MetricItem(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  label: 'Rest',
                  value: '$restTime sec',
                ),
              ),
          ],
        ),
      ],
    );
  }
}
