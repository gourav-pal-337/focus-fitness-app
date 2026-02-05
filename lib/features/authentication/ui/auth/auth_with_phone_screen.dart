import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../provider/auth_provider.dart';
import 'auth_mode.dart';

class AuthWithPhoneScreen extends StatelessWidget {
  const AuthWithPhoneScreen({super.key, required this.mode});

  final AuthMode mode;

  bool get isLogin => mode == AuthMode.login;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final canProceed = authProvider.canProceedWithPhone;
    final isLoading = authProvider.isLoading;

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
                'Enter your\nMobile Number',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 45.sp,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'We will send you a confirmation code',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _PhoneNumberField(),
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
        text: isLoading ? 'Sending Code...' : 'Continue',
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
                final success = await authProvider.sendOtp(
                  purpose: mode == AuthMode.login ? 'login' : 'signup',
                );

                if (success && context.mounted) {
                  final phoneNumber = authProvider.phoneNumber;
                  final countryCode = authProvider.countryCode;
                  final fullNumber = '$countryCode$phoneNumber';
                  context.push(
                    '/otp-verification/$fullNumber?mode=${mode.name}',
                  );
                } else if (context.mounted && authProvider.isError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(authProvider.errorMessage),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              }
            : null,
      ),
    );
  }
}

class _PhoneNumberField extends StatefulWidget {
  const _PhoneNumberField();

  @override
  State<_PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<_PhoneNumberField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.grey300,
          width: _isFocused ? 1.2 : 1,
        ),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Show country code selector
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.grey300, width: 1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.countryCode,
                    style: AppTextStyle.text16Regular.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: AppColors.grey400,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              cursorColor: AppColors.primary,
              onChanged: provider.updatePhoneNumber,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.grey400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
