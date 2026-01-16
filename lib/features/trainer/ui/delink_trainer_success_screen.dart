import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';

class DelinkTrainerSuccessScreen extends StatelessWidget {
  const DelinkTrainerSuccessScreen({super.key});

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
                    const _DelinkedIcon(),
                    SizedBox(height: AppSpacing.xl),
                    Text(
                      'Trainer Delinked',
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

class _DelinkedIcon extends StatelessWidget {
  const _DelinkedIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Chain links icon - using custom painter for better control
          Icon(
            Icons.link,
            size: 100.sp,
            color: Colors.red,
          ),
          // Diagonal line through the links
          Transform.rotate(
            angle: -0.785, // -45 degrees in radians
            child: Container(
              width: 120.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2.5.r),
              ),
            ),
          ),
        ],
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

