import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/show_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/expandable_summary_text.dart';
import '../../../../trainer/data/models/trainer_referral_response_model.dart';
import '../../../provider/auth_provider.dart';
import 'trainer_details_sheet.dart';

class TrainerListWidget extends StatelessWidget {
  const TrainerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    if (!provider.hasTrainers) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text(
              '${provider.foundTrainers.length} trainer(s) found',
              style: AppTextStyle.text14SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.grey200),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: provider.foundTrainers.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, thickness: 1, color: AppColors.grey200),
            itemBuilder: (context, index) {
              final trainer = provider.foundTrainers[index];
              final isSelected = provider.selectedTrainer?.id == trainer.id;

              return _TrainerListItem(
                trainer: trainer,
                isSelected: isSelected,
                onTap: () {
                  provider.selectTrainer(trainer);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TrainerListItem extends StatelessWidget {
  const _TrainerListItem({
    required this.trainer,
    required this.isSelected,
    required this.onTap,
  });

  final TrainerInfo trainer;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShowImage(
              imageUrl: trainer.profilePhoto,
              width: 50.w,
              height: 50.w,
              isCircle: true,
              errorWidget: Icon(
                Icons.person,
                size: 24.sp,
                color: AppColors.grey400,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Trainer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trainer.fullName ?? 'Trainer',
                    style: AppTextStyle.text16SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    trainer.referralCode,
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                  if (trainer.previewSummary != null &&
                      trainer.previewSummary!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    ExpandableSummaryText(text: trainer.previewSummary!),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            // Selection Indicator & Info buttons row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                  onPressed: () {
                    showTrainerDetails(context, trainer);
                  },
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
