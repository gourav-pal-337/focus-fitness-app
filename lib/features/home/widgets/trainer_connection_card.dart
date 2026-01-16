import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';
import '../../trainer/provider/linked_trainer_provider.dart';
import 'trainer_connection_card_skeleton.dart';

class TrainerConnectionCard extends StatelessWidget {
  const TrainerConnectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LinkedTrainerProvider>(
      builder: (context, provider, child) {
        // Show loading state with skeleton
        if (provider.isLoading) {
          return const TrainerConnectionCardSkeleton();
        }

        // Show "No Trainer Assigned" UI when not linked
        if (!provider.isLinked || provider.trainer == null) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.medium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Trainer Assigned',
                  style: AppTextStyle.text16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'You are currently not linked with any of our trainers.',
                  style: AppTextStyle.text12Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                GestureDetector(
                  onTap: () {
                    context.push(EnterTrainerIdRoute.path);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Link now',
                        style: AppTextStyle.text14Medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Show trainer info when linked
        final trainer = provider.trainer!;
        final relationshipStatus = provider.profile?.relationshipStatus ?? 'pending';
        final isLive = relationshipStatus == 'live';

        return GestureDetector(
          onTap: () {
            // Navigate to trainer profile screen
            final trainerId = trainer.id;
            if (trainerId.isNotEmpty) {
              context.push(TrainerProfileRoute.path.replaceAll(':trainerId', trainerId));
            }
          },
          child: Container(
            height: 72.h,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.whiteBlue,
              borderRadius: AppRadius.medium,
            ),
            child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: AppColors.grey200,
                backgroundImage: trainer.profilePhoto != null
                    ? NetworkImage(trainer.profilePhoto!)
                    : null,
                child: trainer.profilePhoto == null
                    ? Icon(
                        Icons.person,
                        size: 24.sp,
                        color: AppColors.grey400,
                      )
                    : null,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      trainer.fullName ?? 'Trainer',
                      style: AppTextStyle.text16Medium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // SizedBox(height: 2.h),
                    Text(
                      trainer.referralCode,
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: isLive ? AppColors.green : AppColors.grey400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isLive ? 'Connected' : 'Pending',
                    style: AppTextStyle.text12Medium.copyWith(
                      color: isLive ? AppColors.green : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}

