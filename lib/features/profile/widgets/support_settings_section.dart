import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';
import '../widgets/logout_confirmation_dialog.dart';

class SupportSettingsSection extends StatelessWidget {
  const SupportSettingsSection({
    super.key,
    required this.onLanguagePreferencesTap,
    required this.onLogoutTap,
  });

  final VoidCallback onLanguagePreferencesTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support & Settings',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.medium,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey400.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              _SettingsMenuItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () {
                  context.push(NotificationsRoute.path);
                },
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              _SettingsMenuItem(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy & Security',
                onTap: () {
                  context.push(PrivacySecurityRoute.path);
                },
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              _SettingsMenuItem(
                icon: Icons.person_outline,
                label: 'Account Details',
                onTap: () {
                  context.push(AccountDetailsRoute.path);
                },
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              _SettingsMenuItem(
                icon: Icons.language,
                label: 'Language Preferences',
                onTap: onLanguagePreferencesTap,
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              _SettingsMenuItem(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  LogoutConfirmationDialog.show(
                    context: context,
                    onLogout: onLogoutTap,
                    onCancel: () {
                      // Dialog will close automatically
                    },
                  );
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  const _SettingsMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: color,
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyle.text16Regular.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

