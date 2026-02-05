import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/buttons/buttons.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../core/widgets/inputs/inputs.dart';
import '../../../../routes/app_router.dart';
import '../../provider/auth_provider.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import 'auth_mode.dart';

class AuthWithEmailScreen extends StatefulWidget {
  const AuthWithEmailScreen({super.key, required this.mode});

  final AuthMode mode;

  @override
  State<AuthWithEmailScreen> createState() => _AuthWithEmailScreenState();
}

class _AuthWithEmailScreenState extends State<AuthWithEmailScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get isLogin => widget.mode == AuthMode.login;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    final request = LoginRequestModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    await authProvider.loginWithEmail(request);

    if (authProvider.isLoginSuccess && mounted) {
      await userProvider.fetchUserDetails();
      // Check if email verification is required
      if (authProvider.emailVerificationRequired) {
        // TODO: Navigate to email verification screen
        // For now, navigate to home

        context.go(HomeRoute.path);
      } else {
        // Navigate to home
        context.go(HomeRoute.path);
      }
    } else if (authProvider.isError && mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    final request = RegisterRequestModel(
      fullName: authProvider.name.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      referralCode: authProvider.trainerId.isNotEmpty
          ? authProvider.trainerId
          : null,
    );

    await authProvider.registerWithEmail(request);

    if (authProvider.isRegisterSuccess && mounted) {
      await userProvider.fetchUserDetails();
      // Navigate based on registration success
      if (authProvider.trainerId.isNotEmpty) {
        // Trainer linked, go to onboarding
        AppRouter.router.go(HomeRoute.path);
      } else {
        // No trainer, go to enter trainer ID
        context.go(EnterTrainerIdRoute.path);
      }
    } else if (authProvider.isError && mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoading) {
      return;
    }
    print("google login....");
    await authProvider.signInWithGoogle();
    _handleSocialAuthResult(authProvider);
  }

  Future<void> _handleAppleLogin() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoading) {
      return;
    }
    print("apple login....");
    await authProvider.signInWithApple();
    _handleSocialAuthResult(authProvider);
  }

  Future<void> _handleSocialAuthResult(AuthProvider authProvider) async {
    if (authProvider.isLoginSuccess && mounted) {
      // Assuming social login provides enough info to skip profile setup for now
      // or fetches user details if backend is linked
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

  String _getButtonText(AuthProvider authProvider) {
    if (authProvider.isLoading) {
      switch (authProvider.authMethod) {
        case AuthMethod.google:
          return 'Signing in with Google';
        case AuthMethod.apple:
          return 'Signing in with Apple';
        case AuthMethod.email:
          return isLogin ? 'Signing in...' : 'Signing up...';
      }
    }
    return isLogin ? 'Sign in with Email' : 'Sign up with Email';
  }

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
          child: Form(
            key: _formKey,
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
                _EmailField(controller: _emailController),
                SizedBox(height: AppSpacing.sm),
                _PasswordField(controller: _passwordController),
                if (!isLogin) ...[
                  SizedBox(height: AppSpacing.sm),
                  _ConfirmPasswordField(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                  ),
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
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: _getButtonText(authProvider),
                      size: ButtonSize.large,
                      width: double.infinity,
                      height: 52.h,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.background,
                      icon: authProvider.isLoading
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
                          : Icon(
                              Icons.mail_outline,
                              size: 20.sp,
                              color: AppColors.background,
                            ),
                      textStyle: AppTextStyle.text16SemiBold.copyWith(
                        color: AppColors.background,
                      ),
                      borderRadius: 12.r,
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                              if (isLogin) {
                                _handleLogin();
                              } else {
                                _handleSignUp();
                              }
                            },
                    );
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
                _SocialRow(
                  mode: widget.mode,
                  onGooglePressed: _handleGoogleLogin,
                  onApplePressed: _handleAppleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      hintText: 'Email',
      hintStyle: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
      prefixIcon: Icon(Icons.mail_sharp, size: 20.sp, color: AppColors.grey400),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: 'Password',
      hintStyle: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 20.sp,
        color: AppColors.grey400,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: 'Confirm Password',
      obscureText: true,
      hintStyle: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 20.sp,
        color: AppColors.grey400,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please confirm your password';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
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
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  final AuthMode mode;
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
        // SizedBox(width: AppSpacing.sm),
        // SocialIconButton(
        //   icon: AppImage(path: AppAssets.facebook, width: 24.w, height: 24.h),
        //   onPressed: () {
        //     // TODO: Handle Facebook ${mode == AuthMode.login ? 'login' : 'signup'}.
        //   },
        // ),
      ],
    );
  }
}
