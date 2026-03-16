import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../core/widgets/country_code_picker.dart';
import '../../../../routes/app_router.dart';
import '../../provider/auth_provider.dart';

class TfaPhoneVerificationScreen extends StatefulWidget {
  const TfaPhoneVerificationScreen({super.key});

  @override
  State<TfaPhoneVerificationScreen> createState() =>
      _TfaPhoneVerificationScreenState();
}

class _TfaPhoneVerificationScreenState
    extends State<TfaPhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
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
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final canProceed = _phoneController.text.trim().isNotEmpty;

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
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Two-Factor Authentication',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Please verify your phone number',
                style: AppTextStyle.text18SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Enter the phone number ending with ${authProvider.maskedPhone ?? '*******'}',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              _buildPhoneField(authProvider),
              SizedBox(height: AppSpacing.lg * 2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: CustomButton(
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
                    final phone = _phoneController.text.trim();
                    final countryCode = authProvider.countryCode; 
                    final fullPhone = '$countryCode$phone';
                    final success = await authProvider.sendTfaOtp(fullPhone, countryCode);

                    if (success && context.mounted) {
                      context.push(TfaOtpVerificationRoute.path);
                    } else if (context.mounted && authProvider.isError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(AuthProvider authProvider) {
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
          MyCountryCodePicker(
            selectedCode: authProvider.countryCode,
            selectedFlag: authProvider.countryFlag,
            onCountryCodeTap: (code) {
              if (code != null) {
                authProvider.updateCountryCode(code.dialCode, code.flag);
              }
            },
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              cursorColor: AppColors.primary,
              onChanged: (value) {
                setState(() {}); // Update button state
              },
              decoration: InputDecoration(
                hintText: 'Enter full phone number',
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
