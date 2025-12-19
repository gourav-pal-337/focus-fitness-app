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

import '../../authentication/provider/auth_provider.dart';

class EnterNameScreen extends StatelessWidget {
  const EnterNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AppImage(
            path: AppAssets.login,
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
                    "Let's Create your\nProfile",
                    style: AppTextStyle.text28SemiBold.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Please Enter Your Full Name',
                    style: AppTextStyle.text14Regular.copyWith(
                      color: AppColors.background.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  const _NameField(),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final canProceed = provider.canProceedWithName;

    return AppTextFormField(
      hintText: 'Name',
      textStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.background,
      ),
      hintStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.background.withOpacity(0.7),
      ),
      enabledBorderColor: AppColors.background.withOpacity(0.7),
      focusedBorderColor: AppColors.primary,
      onChanged: provider.updateName,
      prefixIcon: Icon(
        Icons.person_outline,
        color: AppColors.background,
        size: 20.sp,
      ),
      suffixIcon: IconButton(
        onPressed: canProceed
            ? () {
                context.push(SignupWithEmailRoute.path);
              }
            : null,
        icon: Icon(
          Icons.arrow_forward,
          size: 20.sp,
          color: canProceed
              ? AppColors.primary
              : AppColors.background.withOpacity(0.5),
        ),
      ),
    );
  }
}



