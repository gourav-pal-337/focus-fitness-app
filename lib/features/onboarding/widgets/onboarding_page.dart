import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/routes/app_router.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.imagePath,
    this.showPrimaryCta = false,
  });

  final String title;
  final String imagePath;
  final bool showPrimaryCta;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppImage(
          path: imagePath,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.onboardingOverlay,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'FOCUS FUSION',
                    style: AppTextStyle.text32Medium.copyWith(
                      color: AppColors.background,
                      letterSpacing: 2.sp,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: AppTextStyle.text32SemiBold.copyWith(
                    color: AppColors.background,
                  ),
                ),
                // if (showPrimaryCta) ...[
                //   SizedBox(height: AppSpacing.lg),
                //   _OnboardingPrimaryCta(),
                // ],
                SizedBox(height: AppSpacing.lg * 3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPrimaryCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
          text: 'Sign up with Email',
          size: ButtonSize.large,
          width: double.infinity,
          height: 52.h,
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
          icon: Icon(
            Icons.mail_outline,
            size: 20.sp,
            color: AppColors.background,
          ),
          textStyle: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.background,
          ),
          borderRadius: 12.r,
          onPressed: () {
            context.push(EnterNameRoute.path);
          },
        ),
        SizedBox(height: AppSpacing.sm+5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey100,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(LoginWithEmailRoute.path);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign In',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


