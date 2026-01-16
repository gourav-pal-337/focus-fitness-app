import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class TrainerInfoSection extends StatelessWidget {
  const TrainerInfoSection({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    this.imageUrl,
  });

  final String name;
  final String specialty;
  final double rating;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: AppTextStyle.text24SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          specialty,
          style: AppTextStyle.text12Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 16.sp,
              color: Colors.amber,
            ),
            SizedBox(width: 4.w),
            Text(
              '$rating/5',
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

