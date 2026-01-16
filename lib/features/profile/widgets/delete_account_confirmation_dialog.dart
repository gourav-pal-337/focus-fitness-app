import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
  });

  final VoidCallback onDelete;
  final VoidCallback onCancel;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onDelete,
    required VoidCallback onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (context) => DeleteAccountConfirmationDialog(
        onDelete: onDelete,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onCancel,
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.background,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Are you sure you want to\npermanently delete your\naccount?',
                style: AppTextStyle.text20SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'This action cannot be undone',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.grey400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Text(
                    'Delete Account',
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

