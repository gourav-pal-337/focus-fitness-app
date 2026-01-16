import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacySecurityOption extends StatelessWidget {
  const PrivacySecurityOption({
    super.key,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? Colors.red : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: AppSpacing.screenPadding.left,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.text16Regular.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

