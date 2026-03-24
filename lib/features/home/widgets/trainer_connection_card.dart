import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/features/trainer/data/models/trainer_referral_response_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
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
        print("provider.trainer : ${provider.trainer}");
        // Show "No Trainer Assigned" UI when not linked
        if (!provider.isLinked || provider.trainer == null) {
          return Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.grey100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
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
                            'You are currently not linked with any trainer.',
                            style: AppTextStyle.text12Regular.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.person_add_disabled_outlined,
                      color: AppColors.grey400,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'Connect with Trainer',
                  onPressed: () {
                    context.push(EnterTrainerIdRoute.path);
                  },
                  type: ButtonType.outlined,
                  size: ButtonSize.medium,
                  width: double.infinity,
                  borderRadius: 10.r,
                ),
              ],
            ),
          );
        }

        // Show trainer info when linked
        final trainer = provider.trainer!;
        final relationshipStatus =
            provider.profile?.relationshipStatus ?? 'pending';
        final isLive = relationshipStatus == 'live';

        return Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.whiteBlue,
            borderRadius: AppRadius.medium,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  final trainerId = trainer.id;
                  if (trainerId.isNotEmpty) {
                    context.push(TrainerProfileRoute.path, extra: trainer);
                  }
                },
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
              if (isLive) ...[
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'Book Your Session',
                  onPressed: () {
                    final trainerId = trainer.id;
                    if (trainerId.isNotEmpty) {
                      final uri = Uri(
                        path: TrainerProfileRoute.path.replaceAll(
                          ':trainerId',
                          trainerId,
                        ),
                        queryParameters: {'scrollToBooking': 'true'},
                      ).toString();
                      context.push(uri, extra: trainer);
                    }
                  },
                  type: ButtonType.gradient,
                  gradientColors: [
                    Colors.black,
                    Colors.grey.shade800,
                    Colors.grey.shade700,
                  ],
                  width: double.infinity,
                  size: ButtonSize.medium,
                  borderRadius: 12.r,
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
