import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/auth_provider.dart';
import '../../../routes/app_router.dart';
import 'auth/auth_mode.dart';

class VerificationSelectionScreen extends StatelessWidget {
  const VerificationSelectionScreen({
    super.key,
    required this.email,
    required this.countryCode,
    required this.phone,
  });

  final String email;
  final String countryCode;
  final String phone;

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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Your\nAccount',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Choose how you want to receive your code.',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.xl * 2),

              const _SelectionOptions(),

              const Spacer(),
              const _ErrorDisplay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionOptions extends StatelessWidget {
  const _SelectionOptions();

  @override
  Widget build(BuildContext context) {
    // We use a StatefulWidget internally or just read local state if needed.
    // For now, simplify and reactive to AuthProvider.
    final screen = context
        .findAncestorWidgetOfExactType<VerificationSelectionScreen>()!;

    final authProvider = context.watch<AuthProvider>();

    return Column(
      children: [
        _SelectionTile(
          title: 'Verify via Email',
          subtitle: screen.email,
          icon: Icons.email_outlined,
          isLoading: authProvider.isEmailOtpLoading,
          onTap: () async {
            final success = await authProvider.sendEmailOtp(screen.email, purpose: 'verification');
            if (success && context.mounted) {
              context.push(
                OtpVerificationRoute.path,
                extra: {
                  'type': 'email',
                  'identifier': screen.email,
                  'mode': AuthMode.signup,
                  'purpose': 'verification',
                },
              );
            }
          },
        ),
        SizedBox(height: AppSpacing.md),
        _SelectionTile(
          title: 'Verify via SMS',
          subtitle: screen.phone,
          icon: Icons.sms_outlined,
          isLoading: authProvider.isPhoneOtpLoading,
          onTap: () async {
            final success = await authProvider.sendPhoneOtp(
              screen.countryCode,
              screen.phone,
              purpose: 'verification',
            );
            if (success && context.mounted) {
              context.push(
                OtpVerificationRoute.path,
                extra: {
                  'type': 'phone',
                  'countryCode': screen.countryCode,
                  'identifier': screen.phone,
                  'mode': AuthMode.signup,
                  'purpose': 'verification',
                },
              );
            }
          },
        ),
      ],
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  const _ErrorDisplay();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        if (provider.isError) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xl),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: AppRadius.medium,
                ),
                child: Text(
                  provider.errorMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: AppRadius.large,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: AppRadius.medium,
                ),
                child: Icon(icon, color: AppColors.primary, size: 20.sp),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.text14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey300,
                  size: 14.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
