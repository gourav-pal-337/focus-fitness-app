import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/skeleton/skeleton_loader.dart';

/// Skeleton loader specifically for the trainer connection card
class TrainerConnectionCardSkeleton extends StatelessWidget {
  const TrainerConnectionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.whiteBlue,
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          // Avatar skeleton
          SkeletonLoader(
            width: 52.w,
            height: 52.w,
            borderRadius: BorderRadius.circular(26.r),
          ),
          SizedBox(width: AppSpacing.md),
          // Text content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name skeleton
                SkeletonLoader(
                  width: 120.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 8.h),
                // Referral code skeleton
                SkeletonLoader(
                  width: 80.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
          // Status skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonLoader(
                width: 8.w,
                height: 8.w,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(height: 4.h),
              SkeletonLoader(
                width: 60.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

