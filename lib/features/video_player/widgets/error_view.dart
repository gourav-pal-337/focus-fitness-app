import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class VideoErrorView extends StatelessWidget {
  const VideoErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey75,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: AppColors.grey400,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Failed to load video',
                style: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Retry',
                type: ButtonType.filled,
                onPressed: onRetry,
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

