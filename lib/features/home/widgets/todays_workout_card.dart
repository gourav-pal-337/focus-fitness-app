import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class TodaysWorkoutSection extends StatelessWidget {
  const TodaysWorkoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Workout",
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(height: 1.h, color: AppColors.grey200),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _TodaysWorkoutCard(),
      ],
    );
  }
}

class _TodaysWorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/session-history');
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.whiteBlue,
              borderRadius: AppRadius.large,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 104.w,
                  height: 100.h,
                  child: ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
                      width: 104.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(height: AppSpacing.sm),
                      Text(
                        'Strength Training',
                        style: AppTextStyle.text16Medium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'with Alex',
                        style: AppTextStyle.text12Regular.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            // top: -8.h,
            top: 0,
            right: AppSpacing.md,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(6.r),
                ),
              ),
              child: Text(
                'Intermediate',
                style: AppTextStyle.text10Regular.copyWith(
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
