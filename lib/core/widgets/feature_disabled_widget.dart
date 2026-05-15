import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class FeatureDisabledWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const FeatureDisabledWidget({
    super.key,
    this.title = 'Feature Unavailable',
    this.message =
        'This feature is currently disabled. Please check back later.',
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48.sp, color: AppColors.primary),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          title,
          style: AppTextStyle.text20SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          message,
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.textSecondary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
