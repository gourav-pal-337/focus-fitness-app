import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SubscriptionFeaturesList extends StatelessWidget {
  const SubscriptionFeaturesList({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      'All features from the Weekly Plan',
      'Free access to premium workshops',
      'Personalized fitness coaching sessions',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14.sp,
                  color: AppColors.background,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                feature,
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

