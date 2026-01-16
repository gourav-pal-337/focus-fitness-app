import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../routes/app_router.dart';

class FeedbackSuccessScreen extends StatelessWidget {
  const FeedbackSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),
                    _SuccessIcon(),
                    SizedBox(height: AppSpacing.xl),
                    Text(
                      'Thank you for the feedback!',
                      style: AppTextStyle.text24SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium.',
                      style: AppTextStyle.text16Medium.copyWith(
                        color: AppColors.grey400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            _GoToHomeButton(),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: AppRadius.extraLarge,
      ),
      child: Center(
        child: Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
          ),
          child: Icon(
            Icons.check,
            size: 40.sp,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _GoToHomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        text: 'Go to Home Screen',
        type: ButtonType.filled,
        onPressed: () {
          context.go(HomeRoute.path);
        },
        width: double.infinity,
        backgroundColor: AppColors.primary,
        textColor: AppColors.background,
        borderRadius: 12.r,
      ),
    );
  }
}

