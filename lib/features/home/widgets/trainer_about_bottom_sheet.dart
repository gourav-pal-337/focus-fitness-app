import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../trainer/data/models/trainer_referral_response_model.dart';

class TrainerAboutBottomSheet extends StatelessWidget {
  const TrainerAboutBottomSheet({required this.trainer});

  final TrainerInfo trainer;

  static Future<void> show({
    required BuildContext context,
    required TrainerInfo trainer,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TrainerAboutBottomSheet(trainer: trainer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left)
                  .copyWith(top: AppSpacing.md, bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.close,
                    size: 24.sp,
                    color: Colors.transparent,
                  ),
                  Text(
                    'About Trainer',
                    style: AppTextStyle.text20SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bio Summary Section
                    if (trainer.bioSummary != null && trainer.bioSummary!.isNotEmpty) ...[
                      TrainerDetailSection(
                        title: 'Bio Summary',
                        content: trainer.bioSummary!,
                      ),
                      SizedBox(height: AppSpacing.lg),
                    ],
                    
                    // Expertise Areas Section
                    if (trainer.expertiseAreas != null && trainer.expertiseAreas!.isNotEmpty) ...[
                      TrainerDetailSection(
                        title: 'Expertise Areas',
                        content: trainer.expertiseAreas!.join(', '),
                      ),
                      SizedBox(height: AppSpacing.lg),
                    ],
                    
                    // Training Philosophy Section
                    if (trainer.trainingPhilosophy != null && trainer.trainingPhilosophy!.isNotEmpty) ...[
                      TrainerDetailSection(
                        title: 'Training Philosophy',
                        content: trainer.trainingPhilosophy!,
                      ),
                      SizedBox(height: AppSpacing.lg),
                    ],
                    
                    // Session Types Section
                    if (trainer.sessionTypes != null && trainer.sessionTypes!.isNotEmpty) ...[
                      TrainerDetailSection(
                        title: 'Session Types',
                        content: trainer.sessionTypes!.join(', '),
                      ),
                      SizedBox(height: AppSpacing.lg),
                    ],
                    
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainerDetailSection extends StatelessWidget {
  const TrainerDetailSection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          content,
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

