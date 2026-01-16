import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

enum WorkoutDifficulty {
  beginner,
  intermediate,
  advanced,
}

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String duration;
  final WorkoutDifficulty difficulty;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.medium,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey400.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180.h,
                        color: AppColors.grey75,
                        child: Icon(
                          Icons.fitness_center,
                          size: 48.sp,
                          color: AppColors.grey400,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: AppSpacing.md,
                  left: AppSpacing.md,
                  child: _PlayButton(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.text16SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: AppColors.grey400,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        duration,
                        style: AppTextStyle.text12Regular.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _DifficultyBadge(difficulty: difficulty),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.play_arrow,
        size: 24.sp,
        color: AppColors.background,
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final WorkoutDifficulty difficulty;

  String get _label {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return 'Beginner';
      case WorkoutDifficulty.intermediate:
        return 'Intermediate';
      case WorkoutDifficulty.advanced:
        return 'Advanced';
    }
  }

  Color get _backgroundColor {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return AppColors.greenLight;
      case WorkoutDifficulty.intermediate:
        return Colors.orange.withValues(alpha: 0.2);
      case WorkoutDifficulty.advanced:
        return Colors.red.withValues(alpha: 0.2);
    }
  }

  Color get _textColor {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return AppColors.green;
      case WorkoutDifficulty.intermediate:
        return Colors.orange.shade700;
      case WorkoutDifficulty.advanced:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.small,
      ),
      child: Text(
        _label,
        style: AppTextStyle.text10Regular.copyWith(
          color: _textColor,
        ),
      ),
    );
  }
}

