import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.message,
    required this.timestamp,
    this.isRead = true,
    this.onTap,
  });

  final String message;
  final String timestamp;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // Unread rows get a subtle tinted background.
        color: isRead
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: 0.06),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.left,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fitness_center_outlined,
                size: 24.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style:
                        (isRead
                                ? AppTextStyle.text16Regular
                                : AppTextStyle.text16SemiBold)
                            .copyWith(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    timestamp,
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            // Unread dot indicator.
            if (!isRead)
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}


