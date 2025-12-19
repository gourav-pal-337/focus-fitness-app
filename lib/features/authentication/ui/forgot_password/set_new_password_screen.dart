import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../core/widgets/inputs/inputs.dart';
import '../../../../routes/app_router.dart';
import '../../provider/forgot_password_provider.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canProceed = context.watch<ForgotPasswordProvider>().canProceedWithPassword;

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
                'Set a New\nPassword',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm + 5),
              Text(
                'Create a new password. Ensure it differs from the previous for security',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _PasswordField(),
              SizedBox(height: AppSpacing.md),
              const _ConfirmPasswordField(),
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
        text: 'Update Password',
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
            ? () {
                _showSuccessModal(context);
              }
            : null,
      ),
    );
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const _PasswordResetSuccessModal(),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ForgotPasswordProvider>();

    return AppTextFormField(
      hintText: 'Password',
      obscureText: true,
      hintStyle: AppTextStyle.text14Regular.copyWith(
        color: AppColors.grey400,
      ),
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 20.sp,
        color: AppColors.grey400,
      ),
      enabledBorderColor: AppColors.grey300,
      focusedBorderColor: AppColors.primary,
      textStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.textPrimary,
      ),
      onChanged: provider.updateNewPassword,
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ForgotPasswordProvider>();

    return AppTextFormField(
      hintText: 'Confirm Password',
      obscureText: true,
      hintStyle: AppTextStyle.text14Regular.copyWith(
        color: AppColors.grey400,
      ),
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 20.sp,
        color: AppColors.grey400,
      ),
      enabledBorderColor: AppColors.grey300,
      focusedBorderColor: AppColors.primary,
      textStyle: AppTextStyle.text16Regular.copyWith(
        color: AppColors.textPrimary,
      ),
      onChanged: provider.updateConfirmPassword,
    );
  }
}

class _PasswordResetSuccessModal extends StatelessWidget {
  const _PasswordResetSuccessModal();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
      ),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.extraLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 48.sp,
                color: AppColors.background,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Password Reset Successful',
              textAlign: TextAlign.center,
              style: AppTextStyle.text18Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Your password has been successfully updated. You can now use your new password to log in.',
              textAlign: TextAlign.center,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg * 1.5),
            CustomButton(
              text: 'Confirm',
              size: ButtonSize.large,
              width: double.infinity,
              height: 52.h,
              backgroundColor: AppColors.primary,
              textColor: AppColors.background,
              textStyle: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.background,
              ),
              borderRadius: 12.r,
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login screen
                context.go(LoginWithEmailRoute.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}

