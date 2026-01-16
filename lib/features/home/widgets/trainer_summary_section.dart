import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../trainer/provider/linked_trainer_provider.dart';
import 'trainer_about_section.dart';
import 'trainer_certificates_section.dart';

class TrainerSummarySection extends StatelessWidget {
  const TrainerSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LinkedTrainerProvider>(
      builder: (context, provider, child) {
        // Only show if trainer is linked
        if (!provider.isLinked || provider.trainer == null) {
          return const SizedBox.shrink();
        }

        final trainer = provider.trainer!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with line
            Row(
              children: [
                Text(
                  'Trainer Summary',
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
            SizedBox(height: AppSpacing.lg),

            // About Section
            TrainerAboutSection(trainer: trainer),
            SizedBox(height: AppSpacing.lg),

            // Certificates Section
            TrainerCertificatesSection(trainer: trainer),
          ],
        );
      },
    );
  }
}
