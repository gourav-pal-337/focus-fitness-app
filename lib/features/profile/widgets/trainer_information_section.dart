import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/skeleton/skeleton_loader.dart';
import '../../trainer/provider/linked_trainer_provider.dart';
import 'profile_action_card.dart';
import 'profile_detail_card.dart';

class TrainerInformationSection extends StatelessWidget {
  const TrainerInformationSection({
    super.key,
    required this.onDelink,
  });

  final VoidCallback onDelink;

  @override
  Widget build(BuildContext context) {
    return Consumer<LinkedTrainerProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trainer Information',
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            // Show loading skeleton
            if (provider.isLoading)
              _TrainerInformationSkeleton()
            // Show "No Trainer" message when not linked
            else if (!provider.isLinked || provider.trainer == null)
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Trainer Linked',
                      style: AppTextStyle.text14Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'You are not currently linked with any trainer.',
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              )
            // Show trainer information when linked
            else
              ProfileActionCard(
                items: [
                  ProfileDetailItem(
                    label: 'Linked Trainer',
                    value: provider.trainer!.fullName ?? 'Trainer',
                  ),
                  ProfileDetailItem(
                    label: 'Trainer ID',
                    value: provider.trainer!.referralCode,
                  ),
                ],
                actionLabel: 'Delink Trainer',
                actionIcon: Icons.link_off,
                onAction: onDelink,
              ),
          ],
        );
      },
    );
  }
}

class _TrainerInformationSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 11.h,
              horizontal: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(
                  width: 100.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SkeletonLoader(
                  width: 120.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 11.h,
              horizontal: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(
                  width: 80.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SkeletonLoader(
                  width: 100.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: AppSpacing.md,
            ),
            child: Center(
              child: SkeletonLoader(
                width: 120.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

