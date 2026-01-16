import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../trainer/data/models/trainer_referral_response_model.dart';
import 'trainer_about_bottom_sheet.dart';

class TrainerAboutSection extends StatelessWidget {
  const TrainerAboutSection({required this.trainer});

  final TrainerInfo trainer;

  /// Get preview text (always truncated to show less)
  String _getPreviewText() {
    // Always show a truncated preview - prioritize bio summary
    if (trainer.bioSummary != null && trainer.bioSummary!.isNotEmpty) {
      final bio = trainer.bioSummary!;
      // Always truncate to max 60 characters for preview
      if (bio.length > 60) {
        // Try to break at a sentence first
        final firstSentence = bio.split('.').first;
        if (firstSentence.length <= 60 && firstSentence.isNotEmpty) {
          return '$firstSentence.';
        }
        // Otherwise break at word boundary
        final truncated = bio.substring(0, 60);
        final lastSpace = truncated.lastIndexOf(' ');
        if (lastSpace > 40) {
          return '${truncated.substring(0, lastSpace)}...';
        }
        return '$truncated...';
      }
      // Even if short, add ellipsis to indicate there's more
      return '$bio...';
    }
    
    // Fallback to expertise if no bio
    if (trainer.expertiseAreas != null && trainer.expertiseAreas!.isNotEmpty) {
      final expertise = trainer.expertiseAreas!.join(', ');
      // Truncate if too long
      if (expertise.length > 60) {
        return 'Specializes in ${expertise.substring(0, 60)}...';
      }
      return 'Specializes in $expertise.';
    }
    
    return 'Certified fitness trainer with experience in personalized training.';
  }

  /// Check if there's more content to show
  bool _hasMoreContent() {
    // Always show "Show more" button if there's any trainer data
    // This allows users to see the organized view in bottom sheet
    bool hasBio = trainer.bioSummary != null && trainer.bioSummary!.isNotEmpty;
    bool hasExpertise = trainer.expertiseAreas != null && trainer.expertiseAreas!.isNotEmpty;
    bool hasPhilosophy = trainer.trainingPhilosophy != null && trainer.trainingPhilosophy!.isNotEmpty;
    bool hasSessionTypes = trainer.sessionTypes != null && trainer.sessionTypes!.isNotEmpty;
    
    // Show button if we have any content at all
    return hasBio || hasExpertise || hasPhilosophy || hasSessionTypes;
  }

  @override
  Widget build(BuildContext context) {
    final previewText = _getPreviewText();
    final hasMore = _hasMoreContent();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'About',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6.h, right: AppSpacing.sm),
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  previewText,
                  style: AppTextStyle.text12Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (hasMore) ...[
            SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () {
                TrainerAboutBottomSheet.show(context: context, trainer: trainer);
              },
              child: Row(
                children: [
                  Text(
                    'Show more',
                    style: AppTextStyle.text14Medium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: AppSpacing.lg),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
            height: 0,
          ),
        ],
      ),
    );
  }
}

