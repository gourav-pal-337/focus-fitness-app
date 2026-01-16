import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class DateTimeBar extends StatelessWidget {
  const DateTimeBar({
    super.key,
    required this.date,
    required this.time,
    this.showIfNull = false,
    this.margin,
  });

  final String? date;
  final String? time;
  final bool showIfNull;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    if ((date == null || time == null) && !showIfNull) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: margin ??
          EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      padding: EdgeInsets.all(AppSpacing.sm).copyWith(
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteBlue,
        borderRadius: AppRadius.small,
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 16.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              date ?? '',
              style: AppTextStyle.text12SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            time ?? '',
            style: AppTextStyle.text12Regular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

