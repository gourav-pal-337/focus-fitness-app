import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/workout_provider.dart';

class ExerciseOverviewSection extends StatelessWidget {
  const ExerciseOverviewSection({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  String _getLevelText(ExerciseLevel level) {
    switch (level) {
      case ExerciseLevel.beginner:
        return 'Beginner';
      case ExerciseLevel.intermediate:
        return 'Intermediate';
      case ExerciseLevel.advanced:
        return 'Advanced';
    }
  }

  String _getIntensityText(ExerciseIntensity intensity) {
    switch (intensity) {
      case ExerciseIntensity.low:
        return 'Low';
      case ExerciseIntensity.moderate:
        return 'Moderate';
      case ExerciseIntensity.high:
        return 'High';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricsRow(
          level: _getLevelText(exercise.level),
          averageMinutes: exercise.averageMinutes,
          intensity: _getIntensityText(exercise.intensity),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          exercise.description,
          style: AppTextStyle.text16Regular.copyWith(
            color: AppColors.grey400,
            height: 1.2,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        RichText(text: TextSpan(children: [
          TextSpan(text: 'Calories: ', style: AppTextStyle.text14SemiBold.copyWith(
            color: AppColors.textPrimary,
          )),
          TextSpan(text: '${exercise.calories} cal', style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.grey400,
          )),
        ])),
       
        SizedBox(height: AppSpacing.lg),
        Text(
          'Good For',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          exercise.goodFor.join(', '),
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.textPrimary,
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

