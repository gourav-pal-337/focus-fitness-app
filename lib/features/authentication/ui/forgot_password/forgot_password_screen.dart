import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../core/widgets/inputs/inputs.dart';
import '../../provider/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgotPasswordProvider>();
    final canProceed = provider.canProceedWithEmail && !provider.isRequestingReset;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            bottom: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Forgot\nPassword',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm + 5),
              Text(
                'Please enter your email to reset your password',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _EmailField(),
              SizedBox(height: AppSpacing.md),
              const _ErrorDisplay(),
              SizedBox(height: AppSpacing.lg * 2),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.only(
          left: AppSpacing.screenPadding.left,
          right: AppSpacing.screenPadding.right,
          bottom: AppSpacing.lg,
        ),
        text: provider.isRequestingReset ? 'Sending...' : 'Reset Password',
        size: ButtonSize.large,
        width: double.infinity,
        height: 52.h,
        backgroundColor: canProceed ? AppColors.primary : AppColors.grey300,
        textColor: AppColors.background,
        textStyle: AppTextStyle.text16SemiBold.copyWith(
          color: AppColors.background,
        ),
        borderRadius: 12.r,
        isEnabled: canProceed,
        onPressed: canProceed
            ? () async {
                final provider = context.read<ForgotPasswordProvider>();
                final success = await provider.requestPasswordReset();
                
                if (success && context.mounted) {
                  final email = provider.resetEmail;
                  context.push('/check-email/$email');
                }
                // Error is shown in _ErrorDisplay widget
              }
            : null,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ForgotPasswordProvider>();

    return AppTextFormField(
      keyboardType: TextInputType.emailAddress,
      hintText: 'Email',
      hintStyle: AppTextStyle.text14Regular.copyWith(
        color: AppColors.grey400,
      ),
      prefixIcon: Icon(
        Icons.mail_sharp,
        size: 20.sp,
        color: AppColors.grey400,
      ),
      enabledBorderColor: AppColors.grey300,
      focusedBorderColor: AppColors.primary,
      textStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.textPrimary,
      ),
      onChanged: provider.updateResetEmail,
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  const _ErrorDisplay();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgotPasswordProvider>();
    
    if (provider.resetRequestError != null) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 20.sp,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                provider.resetRequestError!,
                style: AppTextStyle.text14Regular.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
}

