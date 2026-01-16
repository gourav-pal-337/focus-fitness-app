import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../trainer/data/models/trainer_referral_response_model.dart';
import '../../../provider/auth_provider.dart';

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
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
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
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey200,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: provider.foundTrainers.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: AppColors.grey200,
            ),
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
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            // Profile Photo
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey200,
                image: trainer.profilePhoto != null
                    ? DecorationImage(
                        image: NetworkImage(trainer.profilePhoto!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: trainer.profilePhoto == null
                  ? Icon(
                      Icons.person,
                      size: 24.sp,
                      color: AppColors.grey400,
                    )
                  : null,
            ),
            SizedBox(width: AppSpacing.md),
            // Trainer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.fullName ?? 'Trainer',
                    style: AppTextStyle.text16SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    trainer.referralCode,
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                  if (trainer.bioSummary != null && trainer.bioSummary!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      trainer.bioSummary!,
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}

