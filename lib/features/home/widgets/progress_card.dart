import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Progress',
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                height: 1.h,
                color: AppColors.grey200,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _ProgressCard(),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workout this week',
                  style: AppTextStyle.text16Regular.copyWith(
                    color: AppColors.background,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '3/5',
                      style: AppTextStyle.text48Bold.copyWith(
                        color: AppColors.background,
                        fontSize: 70.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Text(
                        'days',
                        style: AppTextStyle.text16Regular.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

