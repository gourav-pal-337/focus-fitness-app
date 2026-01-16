import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({
    super.key,
    required this.onLogout,
    required this.onCancel,
  });

  final VoidCallback onLogout;
  final VoidCallback onCancel;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onLogout,
    required VoidCallback onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (context) => LogoutConfirmationDialog(
        onLogout: onLogout,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.xl,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.medium,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.left),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.md),
              Text(
                'Are you sure you want to log out?',
                style: AppTextStyle.text20SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'You will need to enter your phone number to log in again',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.grey400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onLogout();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Text(
                    'Log Out',
                    style: AppTextStyle.text16SemiBold.copyWith(
                      color: AppColors.background,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

