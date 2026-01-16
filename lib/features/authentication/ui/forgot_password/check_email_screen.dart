import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../provider/forgot_password_provider.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    final canProceed = context.watch<ForgotPasswordProvider>().canProceedWithEmailCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            bottom: 100.h,
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
                'Check your email',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm + 5),
              Text(
                'We sent a reset code to $email. Enter 6 digit code that mentioned in the email',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _EmailCodeInputFields(),
              SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Haven't got the email yet? ",
                    style: AppTextStyle.text16Regular.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final provider = context.read<ForgotPasswordProvider>();
                      await provider.requestPasswordReset();
                    },
                    child: Text(
                      'Resend email',
                      style: AppTextStyle.text16Regular.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
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
        text: 'Verify code',
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
                context.push('/set-new-password');
              }
            : null,
      ),
    );
  }
}

class _EmailCodeInputFields extends StatelessWidget {
  const _EmailCodeInputFields();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgotPasswordProvider>();
    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 50.h,
      textStyle: AppTextStyle.text24Bold.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      onCompleted: (pin) {
        provider.updateEmailCode(pin);
      },
      onChanged: (value) {
        provider.updateEmailCode(value);
      },
      keyboardType: TextInputType.number,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 24.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

