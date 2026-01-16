import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/contact_support_provider.dart';

class AttachScreenshotWidget extends StatelessWidget {
  const AttachScreenshotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSupportProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attach Screenshot',
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                // TODO: Implement image picker
                // For now, just a placeholder
              },
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.small,
                  border: Border.all(
                    color: AppColors.grey200,
                    width: 1,
                  ),
                ),
                child: provider.screenshotPath != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: AppRadius.small,
                            child: Image.asset(
                              provider.screenshotPath!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: GestureDetector(
                              onTap: () {
                                provider.updateScreenshotPath(null);
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16.sp,
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 64.sp,
                          color: AppColors.grey400,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}


