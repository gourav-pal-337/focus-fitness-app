import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/inputs/inputs.dart';
import '../../../core/widgets/country_code_picker.dart';
import '../provider/auth_provider.dart';
import '../data/models/register_request_model.dart';
import '../../../routes/app_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/buttons/buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _countryCode = '+91';
  bool _isPhoneFocused = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final fullName = '${authProvider.forename} ${authProvider.surname}';
    final phoneNumber = _phoneController.text.trim();

    final request = RegisterRequestModel(
      forename: authProvider.forename,
      surname: authProvider.surname,
      fullName: fullName,
      email: _emailController.text.trim(),
      countryCode: _countryCode,
      phone: phoneNumber,
      password: _passwordController.text.trim(),
    );

    authProvider.setPendingRegisterRequest(request);

    if (mounted) {
      // Pass email/phone for verification screen
      context.push(
        VerificationSelectionRoute.path,
        extra: {
          'email': _emailController.text.trim(),
          'countryCode': _countryCode,
          'phone': phoneNumber,
        },
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoading) return;
    await authProvider.signInWithGoogle();
    _handleSocialAuthResult(authProvider);
  }

  Future<void> _handleAppleLogin() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoading) return;
    await authProvider.signInWithApple();
    _handleSocialAuthResult(authProvider);
  }

  Future<void> _handleSocialAuthResult(AuthProvider authProvider) async {
    if (authProvider.tfaRequired && mounted) {
      context.push(TfaPhoneVerificationRoute.path);
      return;
    }
    if (authProvider.isLoginSuccess && mounted) {
      context.go(HomeRoute.path);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create\nAccount',
                  style: AppTextStyle.text48Bold.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Complete your profile to join.',
                  style: AppTextStyle.text16Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),

                AppTextFormField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  hintStyle: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    size: 20.sp,
                    color: AppColors.grey400,
                  ),
                  enabledBorderColor: AppColors.grey300,
                  validator: (v) {
                    if (v?.isEmpty ?? true) return 'Email is required';
                    if (!v!.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.sm),

                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isPhoneFocused = hasFocus;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isPhoneFocused
                            ? AppColors.primary
                            : AppColors.grey300,
                        width: _isPhoneFocused ? 1.2 : 1,
                      ),
                      borderRadius: AppRadius.medium,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: MyCountryCodePicker(
                            selectedCode: _countryCode,
                            selectedFlag: '🇮🇳',
                            onCountryCodeTap: (code) {
                              if (code != null) {
                                setState(() {
                                  _countryCode = code.dialCode;
                                });
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: AppTextStyle.text16Regular.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            cursorColor: AppColors.primary,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: AppTextStyle.text14Regular.copyWith(
                                color: AppColors.grey400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 14.h,
                              ),
                            ),
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),

                AppTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  hintStyle: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  obscureText: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 20.sp,
                    color: AppColors.grey400,
                  ),
                  enabledBorderColor: AppColors.grey300,
                  validator: (v) {
                    if (v == null || v.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.sm),

                AppTextFormField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  hintStyle: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  obscureText: true,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 20.sp,
                    color: AppColors.grey400,
                  ),
                  enabledBorderColor: AppColors.grey300,
                  validator: (v) {
                    if (v != _passwordController.text)
                      return 'Passwords match fail';
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.xl * 1.5),

                Consumer<AuthProvider>(
                  builder: (context, provider, _) {
                    return CustomButton(
                      text: provider.isLoading
                          ? 'Creating...'
                          : 'Create Account',
                      size: ButtonSize.large,
                      width: double.infinity,
                      isEnabled: !provider.isLoading,
                      onPressed: _handleRegister,
                    );
                  },
                ),
                SizedBox(height: AppSpacing.lg * 1.5),

                const _SocialDivider(),
                SizedBox(height: AppSpacing.lg),
                _SocialRow(
                  onGooglePressed: _handleGoogleLogin,
                  onApplePressed: _handleAppleLogin,
                ),
                SizedBox(height: AppSpacing.lg),
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: AppTextStyle.text14Regular.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: AppTextStyle.text14Medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialDivider extends StatelessWidget {
  const _SocialDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            'or continue with',
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.grey400,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          icon: AppImage(path: AppAssets.google, width: 28.w, height: 28.h),
          onPressed: onGooglePressed,
        ),
        SizedBox(width: AppSpacing.sm),
        if (Platform.isIOS)
          SocialIconButton(
            icon: AppImage(path: AppAssets.apple, width: 24.w, height: 24.h),
            onPressed: onApplePressed,
          ),
      ],
    );
  }
}
