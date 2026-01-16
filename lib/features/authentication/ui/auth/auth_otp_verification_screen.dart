import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../routes/app_router.dart';
import '../../provider/auth_provider.dart';
import 'auth_mode.dart';

class AuthOtpVerificationScreen extends StatelessWidget {
  const AuthOtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.mode,
  });

  final String mobileNumber;
  final AuthMode mode;

  bool get isLogin => mode == AuthMode.login;

  String get _maskedMobileNumber {
    if (mobileNumber.length >= 4) {
      return '******${mobileNumber.substring(mobileNumber.length - 4)}';
    }
    return mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = context.watch<AuthProvider>().canProceedWithOtp;

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
                'OTP Verification',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the 4-digit OTP sent to your mobile number ending with $_maskedMobileNumber',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _OtpInputFields(),
              SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Handle resend code
                  },
                  child: Text(
                    'Resend Code',
                    style: AppTextStyle.text16Regular.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
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
        text: isLogin ? 'Sign in' : 'Sign up',
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
                if (isLogin) {
                  context.go(HomeRoute.path);
                } else {
                  context.push(LinkTrainerRoute.path);
                }
              }
            : null,
      ),
    );
  }
}

class _OtpInputFields extends StatelessWidget {
  const _OtpInputFields();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 60.h,
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
        provider.updateOtp(pin);
      },
      onChanged: (value) {
        provider.updateOtp(value);
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

