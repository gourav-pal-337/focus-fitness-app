import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../routes/app_router.dart';
import '../../provider/auth_provider.dart';
import 'otp_resend_timer.dart';

class TfaOtpVerificationScreen extends StatefulWidget {
  const TfaOtpVerificationScreen({super.key});

  @override
  State<TfaOtpVerificationScreen> createState() =>
      _TfaOtpVerificationScreenState();
}

class _TfaOtpVerificationScreenState extends State<TfaOtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final canProceed = _otpController.text.length == 6;

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
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Enter Verification Code',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the 6-digit OTP sent to your phone number',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              _buildOtpInput(context),
              SizedBox(height: AppSpacing.md),
              const _ResendTimer(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: CustomButton(
          text: isLoading ? 'Verifying...' : 'Verify',
          size: ButtonSize.large,
          width: double.infinity,
          height: 52.h,
          backgroundColor: canProceed ? AppColors.primary : AppColors.grey300,
          textColor: AppColors.background,
          textStyle: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.background,
          ),
          borderRadius: 12.r,
          isEnabled: canProceed && !isLoading,
          icon: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.background,
                    ),
                  ),
                )
              : null,
          onPressed: (canProceed && !isLoading)
              ? () async {
                  await authProvider.verifyTfaOtp(_otpController.text);

                  if (context.mounted) {
                    if (authProvider.isLoginSuccess) {
                      // Fetch user profile and navigate
                      await context.read<UserProvider>().fetchUserDetails();
                      context.go(HomeRoute.path);
                    } else if (authProvider.isError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildOtpInput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 60.h,
      textStyle: AppTextStyle.text24Bold.copyWith(color: AppColors.textPrimary),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey300, width: 1)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );

    return Pinput(
      length: 6,
      controller: _otpController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      onChanged: (value) {
        setState(() {}); // Update button state
      },
      keyboardType: TextInputType.number,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 24.h,
        decoration: BoxDecoration(color: AppColors.primary),
      ),
    );
  }
}

class _ResendTimer extends StatelessWidget {
  const _ResendTimer();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return OtpResendTimer(
      expiresAt: DateTime.now().add(const Duration(seconds: 30)),
      onResend: () {
        if (authProvider.pendingTfaPhone != null &&
            authProvider.pendingTfaPhoneCountry != null) {
          authProvider.sendTfaOtp(
            authProvider.pendingTfaPhone!,
            authProvider.pendingTfaPhoneCountry!,
          );
        }
      },
    );
  }
}
