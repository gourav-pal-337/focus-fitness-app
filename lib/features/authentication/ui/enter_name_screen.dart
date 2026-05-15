import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/inputs/inputs.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../authentication/provider/auth_provider.dart';
import '../../../core/widgets/why_focus_section.dart';

class EnterNameScreen extends StatelessWidget {
  const EnterNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AppImage(path: AppAssets.login, fit: BoxFit.cover),
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
                    "Let's Create your\nProfile",
                    style: AppTextStyle.text28SemiBold.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Please enter your first and last name.',
                    style: AppTextStyle.text14Regular.copyWith(
                      color: AppColors.background.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  const _ForenameField(),
                  SizedBox(height: AppSpacing.sm),
                  const _SurnameField(),
                  SizedBox(height: AppSpacing.lg),
                  const _ProceedButton(),
                  SizedBox(height: AppSpacing.xs),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const _WhyFocusBottomSheet(),
                        );
                      },
                      child: Text(
                        'Why Focus Fusion?',
                        style: AppTextStyle.text14Medium.copyWith(
                          color: AppColors.background.withOpacity(0.8),
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.background.withOpacity(
                            0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForenameField extends StatelessWidget {
  const _ForenameField();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return AppTextFormField(
      hintText: 'Forename',
      textStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.background,
      ),
      hintStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.background.withOpacity(0.7),
      ),
      enabledBorderColor: AppColors.background.withOpacity(0.7),
      focusedBorderColor: AppColors.primary,
      onChanged: provider.updateForename,
      prefixIcon: Icon(
        Icons.person_outline,
        color: AppColors.background,
        size: 20.sp,
      ),
    );
  }
}

class _SurnameField extends StatelessWidget {
  const _SurnameField();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return AppTextFormField(
      hintText: 'Surname',
      textStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.background,
      ),
      hintStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.background.withOpacity(0.7),
      ),
      enabledBorderColor: AppColors.background.withOpacity(0.7),
      focusedBorderColor: AppColors.primary,
      onChanged: provider.updateSurname,
      prefixIcon: Icon(
        Icons.person_outline,
        color: AppColors.background,
        size: 20.sp,
      ),
    );
  }
}

class _ProceedButton extends StatelessWidget {
  const _ProceedButton();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return CustomButton(
      text: 'Continue',
      width: double.infinity,
      isEnabled: provider.canProceedWithProfile,
      onPressed: () {
        context.push(SignupWithEmailRoute.path);
      },
    );
  }
}

class _WhyFocusBottomSheet extends StatelessWidget {
  const _WhyFocusBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          const WhyFocusSection(),
        ],
      ),
    );
  }
}
