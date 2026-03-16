import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/country_code_picker.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/two_factor_auth_provider.dart';

class TwoFactorAuthenticationScreen extends StatelessWidget {
  const TwoFactorAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = TwoFactorAuthProvider();
        provider.initialize(context);
        return provider;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: 'Two-Factor Authentication'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.md),
                      Consumer<TwoFactorAuthProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.screenPadding.left,
                                ),
                                child: Row(
                                  children: [
                                    Switch(
                                      value: provider.isEnabled,
                                      onChanged: provider.isLoading
                                          ? null
                                          : (value) {
                                              provider.toggle(context);
                                            },
                                      activeThumbColor: AppColors.primary,
                                      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                                    ),
                                    SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Enable Two-Factor Authentication',
                                            style: AppTextStyle.text16Regular
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                          SizedBox(height: AppSpacing.xs),
                                          Text(
                                            'Adds extra security when logging in.',
                                            style: AppTextStyle.text14Regular
                                                .copyWith(color: AppColors.grey400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (provider.viewState == TfaViewState.enteringPhone)
                                _buildPhoneInputSection(context, provider),
                              if (provider.viewState == TfaViewState.enteringOtp)
                                _buildOtpSection(context, provider),
                              if (provider.errorMessage.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.all(AppSpacing.md),
                                  child: Text(
                                    provider.errorMessage,
                                    style: AppTextStyle.text14Regular.copyWith(color: Colors.red),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.md),

                      Divider(
                        color: AppColors.grey200,
                        thickness: 1,
                        height: 0,
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputSection(BuildContext context, TwoFactorAuthProvider provider) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Phone Number',
            style: AppTextStyle.text16SemiBold.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: AppRadius.medium,
            ),
            child: Row(
              children: [
                MyCountryCodePicker(
                  selectedCode: provider.countryCode,
                  selectedFlag: provider.countryFlag,
                  onCountryCodeTap: (code) {
                    if (code != null) {
                      provider.updateCountry(code.dialCode, code.flag);
                    }
                  },
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: provider.phoneNumber,
                    onChanged: provider.updatePhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          CustomButton(
            text: provider.isLoading ? 'Sending...' : 'Send OTP',
            onPressed: provider.phoneNumber.isEmpty ? null : () => provider.sendOtp(),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context, TwoFactorAuthProvider provider) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Verification Code',
            style: AppTextStyle.text16SemiBold.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'We sent a code to ${provider.countryCode} ${provider.phoneNumber}',
            style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
          ),
          SizedBox(height: AppSpacing.lg),
          Center(
            child: Pinput(
              length: 6,
              onCompleted: (pin) => provider.verifyOtp(context, pin),
              defaultPinTheme: PinTheme(
                width: 45.w,
                height: 50.h,
                textStyle: AppTextStyle.text18SemiBold.copyWith(color: AppColors.textPrimary),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive code? ",
                style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
              ),
              TextButton(
                onPressed: provider.isLoading ? null : () => provider.sendOtp(),
                child: Text(
                  'Resend',
                  style: AppTextStyle.text14SemiBold.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
