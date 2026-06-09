import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/app_modal_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/show_image.dart';
import '../../../../trainer/data/models/trainer_referral_response_model.dart';
import '../../../provider/auth_provider.dart';

/// Helper function to show trainer details bottom sheet
void showTrainerDetails(BuildContext context, TrainerInfo trainer) {
  showAppModalSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TrainerDetailsSheet(trainer: trainer),
  );
}

class TrainerDetailsSheet extends StatelessWidget {
  final TrainerInfo trainer;

  const TrainerDetailsSheet({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.xl,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Elegant drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Profile Info
                  Row(
                    children: [
                      ShowImage(
                        imageUrl: trainer.profilePhoto,
                        width: 64.w,
                        height: 64.w,
                        isCircle: true,
                        errorWidget: Icon(
                          Icons.person,
                          size: 32.sp,
                          color: AppColors.grey400,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trainer.fullName ?? 'Trainer',
                              style: AppTextStyle.text20SemiBold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Referral Code: ${trainer.referralCode}',
                              style: AppTextStyle.text14Regular.copyWith(
                                color: AppColors.grey400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  SizedBox(height: AppSpacing.md),

                  // Specialties / Expertise Tags
                  if (trainer.expertiseAreas != null &&
                      trainer.expertiseAreas!.isNotEmpty) ...[
                    Text(
                      'Expertise',
                      style: AppTextStyle.text14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: trainer.expertiseAreas!.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyle.text12Medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],

                  // Full Bio
                  if (trainer.bioSummary != null &&
                      trainer.bioSummary!.isNotEmpty) ...[
                    Text(
                      'About the Trainer',
                      style: AppTextStyle.text14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      trainer.bioSummary!,
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],

                  // Training Philosophy
                  if (trainer.trainingPhilosophy != null &&
                      trainer.trainingPhilosophy!.isNotEmpty) ...[
                    Text(
                      'Philosophy',
                      style: AppTextStyle.text14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      trainer.trainingPhilosophy!,
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],

                  // Session Modes
                  if (trainer.sessionTypes != null &&
                      trainer.sessionTypes!.isNotEmpty) ...[
                    Text(
                      'Training Mode',
                      style: AppTextStyle.text14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      trainer.sessionTypes!.join(', '),
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // Bottom Action Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: AppColors.grey300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyle.text14Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    provider.selectTrainer(trainer);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Select Trainer',
                    style: AppTextStyle.text14Medium.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
