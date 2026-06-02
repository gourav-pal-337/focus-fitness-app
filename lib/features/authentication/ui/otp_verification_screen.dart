import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../provider/auth_provider.dart';
import '../../../routes/app_router.dart';
import 'auth/auth_mode.dart';
import 'auth/otp_resend_timer.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.type,
    this.countryCode,
    required this.identifier,
    this.mode = AuthMode.signup,
    this.purpose,
  });

  final String type; // 'email' or 'phone'
  final String? countryCode;
  final String identifier;
  final AuthMode mode;
  final String? purpose;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();
    final otp = _otpController.text.trim();

    if (otp.length < 6) return;
    print("otp: $otp");
    print("widget.type: ${widget.type}");
    print("widget.identifier: ${widget.identifier}");
    print("widget.countryCode: ${widget.countryCode}");
    print("widget.mode: ${widget.mode}");
    // return;
    final purpose = widget.purpose ?? 'verification';
    if (widget.type == 'email') {
      await authProvider.verifyEmailOtp(widget.identifier, otp, purpose: purpose);
    } else {
      await authProvider.verifyPhoneOtp(
        widget.countryCode ?? '',
        widget.identifier,
        otp,
        purpose: purpose,
      );
    }

    if (authProvider.isLoginSuccess && mounted) {
      // If we have a pending register request, call it after verification
      if (authProvider.pendingRegisterRequest != null) {
        await authProvider.register(authProvider.pendingRegisterRequest!);
        if (!authProvider.isRegisterSuccess && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage),
              backgroundColor: AppColors.primary,
            ),
          );
          return;
        }
        authProvider.setPendingRegisterRequest(null);
      }

      await userProvider.fetchUserDetails();

      if (widget.mode == AuthMode.login) {
        context.go(HomeRoute.path);
      } else {
        if (authProvider.trainerId.isNotEmpty) {
          context.go(HomeRoute.path);
        } else {
          context.go(EnterTrainerIdRoute.path);
        }
      }
    } else if (authProvider.isError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: AppColors.primary,
        ),
      );
    }
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
                'Enter the 6-digit OTP sent to\n${widget.type == 'phone' ? '${widget.countryCode}${widget.identifier}' : widget.identifier}',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              _buildOtpInput(context),
              SizedBox(height: AppSpacing.md),
              _ResendTimer(
                type: widget.type,
                identifier: widget.identifier,
                countryCode: widget.countryCode,
                purpose: widget.purpose,
              ),
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
          onPressed: (canProceed && !isLoading) ? _handleVerify : null,
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
      // textInputAction: TextInputAction.none,
      closeKeyboardWhenCompleted: true,
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
  const _ResendTimer({
    required this.type,
    required this.identifier,
    this.countryCode,
    this.purpose,
  });

  final String type;
  final String identifier;
  final String? countryCode;
  final String? purpose;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return OtpResendTimer(
      expiresAt: DateTime.now().add(const Duration(seconds: 30)),
      onResend: () {
        final resendPurpose = purpose ?? 'verification';
        if (type == 'email') {
          authProvider.sendEmailOtp(identifier, purpose: resendPurpose);
        } else {
          authProvider.sendPhoneOtp(countryCode ?? '', identifier, purpose: resendPurpose);
        }
      },
    );
  }
}
