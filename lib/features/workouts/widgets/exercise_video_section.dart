import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';
import '../provider/workout_provider.dart';

class ExerciseVideoSection extends StatelessWidget {
  const ExerciseVideoSection({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: AppColors.grey200,
          thickness: 1,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Watch Video',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        AspectRatio(
          aspectRatio: 16 / 7,
          child: GestureDetector(
            onTap: () {
              if (exercise.videoUrl != null) {
                context.push(
                  '${VideoPlayerRoute.path}?videoUrl=${Uri.encodeComponent(exercise.videoUrl!)}&title=${Uri.encodeComponent(exercise.name)}',
                );
              }
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.medium,
                  child: Image.network(
                    exercise.videoThumbnailUrl ?? exercise.imageUrl,
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200.h,
                        color: AppColors.grey75,
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 48.sp,
                          color: AppColors.grey400,
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        // color: AppColors.background.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.textPrimary, width: 2.w),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        size: 20.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          exercise.name,
          style: AppTextStyle.text12SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text(
              'Beginner',
              style: AppTextStyle.text10Medium.copyWith(
                color: AppColors.grey400,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: AppColors.grey400,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.access_time,
              size: 10.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              '${exercise.videoDurationMinutes} min',
              style: AppTextStyle.text10Medium.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

