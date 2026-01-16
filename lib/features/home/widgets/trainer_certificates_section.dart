import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/file_opener_widget.dart';
import '../../trainer/data/models/trainer_referral_response_model.dart';

class TrainerCertificatesSection extends StatelessWidget {
  const TrainerCertificatesSection({required this.trainer});

  final TrainerInfo trainer;

  @override
  Widget build(BuildContext context) {
    // Get documents from trainer data
    final documents = trainer.documents ?? [];

    // Only show section if there are documents
    if (documents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Certificates',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ...documents.asMap().entries.map((entry) {
            final index = entry.key;
            final document = entry.value;
            final isLast = index == documents.length - 1;

            final hasUrl = document.documentUrl != null && document.documentUrl!.isNotEmpty;
            print('document.documentUrl: ${document.documentUrl}');
            return Column(
              children: [
                // Make entire row clickable if URL exists
                hasUrl
                    ? FileOpenerWidget(
                        url: document.documentUrl!,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Certificate image placeholder
                            Container(
                              width: 80.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: AppColors.grey200,
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: AppColors.textSecondary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.description,
                                  size: 24.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            // Certificate details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document.originalName,
                                    style: AppTextStyle.text12Regular.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${document.field.toUpperCase()} • ${_formatDate(document.uploadedAt)}',
                                    style: AppTextStyle.text10Regular.copyWith(
                                      color: AppColors.grey400,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.open_in_new,
                                        size: 12.sp,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Tap to view',
                                        style: AppTextStyle.text10Regular.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Certificate image placeholder (non-clickable)
                          Container(
                            width: 80.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: AppColors.grey200,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.description,
                                size: 24.sp,
                                color: AppColors.grey400,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          // Certificate details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  document.originalName,
                                  style: AppTextStyle.text12Regular.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${document.field.toUpperCase()} • ${_formatDate(document.uploadedAt)}',
                                  style: AppTextStyle.text10Regular.copyWith(
                                    color: AppColors.grey400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                if (isLast) ...[
                  SizedBox(height: AppSpacing.md),
                  Divider(
                    color: AppColors.grey200,
                    thickness: 1,
                    height: 0,
                  ),
                  SizedBox(height: AppSpacing.md),
                ] else ...[
                  SizedBox(height: AppSpacing.lg),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Format the uploaded date string
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return 'Uploaded ${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Uploaded ${dateString}';
    }
  }
}

