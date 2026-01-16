import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/workout_provider.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.medium,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey400.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.medium,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                exercise.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey75,
                    child: Icon(
                      Icons.fitness_center,
                      size: 48.sp,
                      color: AppColors.grey400,
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                child: Text(
                  exercise.name,
                  style: AppTextStyle.text16SemiBold.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

