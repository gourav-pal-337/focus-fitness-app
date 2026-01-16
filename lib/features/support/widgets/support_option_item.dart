import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SupportOptionItem extends StatelessWidget {
  const SupportOptionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.left,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18.sp,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyle.text14SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextStyle.text12Regular.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

