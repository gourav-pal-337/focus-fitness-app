import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/buttons/buttons.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../core/widgets/inputs/inputs.dart';
import '../../../../routes/app_router.dart';
import 'auth_mode.dart';

class AuthWithEmailScreen extends StatelessWidget {
  const AuthWithEmailScreen({
    super.key,
    required this.mode,
  });

  final AuthMode mode;

  bool get isLogin => mode == AuthMode.login;

  @override
  Widget build(BuildContext context) {
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
                isLogin ? 'Login to your\nAccount' : 'Create\nAccount',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm + 5),
              Text(
                isLogin
                    ? 'Welcome back! Please enter your details'
                    : 'Set up your profile in a few steps.',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _EmailField(),
              SizedBox(height: AppSpacing.sm),
              const _PasswordField(),
              if (!isLogin) ...[
                SizedBox(height: AppSpacing.sm),
                const _ConfirmPasswordField(),
              ],
              if (isLogin) ...[
                SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.push(ForgotPasswordRoute.path);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyle.text16Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.lg * 1.5),
              CustomButton(
                text: isLogin ? 'Sign in with Email' : 'Sign up with Email',
                size: ButtonSize.large,
                width: double.infinity,
                height: 52.h,
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
                icon: Icon(
                  Icons.mail_outline,
                  size: 20.sp,
                  color: AppColors.background,
                ),
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                borderRadius: 12.r,
                onPressed: () {
                  if (isLogin) {
                    // TODO: Handle login action
                  } else {
                    context.push(EnterTrainerIdRoute.path);
                  }
                },
              ),
              SizedBox(height: AppSpacing.sm),
              CustomButton(
                text: 'Use Phone Number instead',
                size: ButtonSize.large,
                width: double.infinity,
                height: 52.h,
                type: ButtonType.outlined,
                backgroundColor: AppColors.background,
                textColor: AppColors.textPrimary,
                borderColor: AppColors.grey300,
                borderRadius: 12.r,
                icon: Icon(
                  Icons.phone_outlined,
                  size: 20.sp,
                  color: AppColors.textPrimary,
                ),
                textStyle: AppTextStyle.text16Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  if (isLogin) {
                    context.push(LoginWithPhoneRoute.path);
                  } else {
                    context.push(SignupWithPhoneRoute.path);
                  }
                },
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _SocialDivider(),
              SizedBox(height: AppSpacing.lg),
              _SocialRow(mode: mode),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
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
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
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
    required this.mode,
  });

  final AuthMode mode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          icon: AppImage(
            path: AppAssets.google,
            width: 28.w,
            height: 28.h,
          ),
          onPressed: () {
            // TODO: Handle Google ${mode == AuthMode.login ? 'login' : 'signup'}.
          },
        ),
        SizedBox(width: AppSpacing.sm),
        SocialIconButton(
          icon: AppImage(
            path: AppAssets.apple,
            width: 24.w,
            height: 24.h,
          ),
          onPressed: () {
            // TODO: Handle Apple ${mode == AuthMode.login ? 'login' : 'signup'}.
          },
        ),
        SizedBox(width: AppSpacing.sm),
        SocialIconButton(
          icon: AppImage(
            path: AppAssets.facebook,
            width: 24.w,
            height: 24.h,
          ),
          onPressed: () {
            // TODO: Handle Facebook ${mode == AuthMode.login ? 'login' : 'signup'}.
          },
        ),
      ],
    );
  }
}

