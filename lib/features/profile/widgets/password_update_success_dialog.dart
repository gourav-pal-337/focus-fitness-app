import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class PasswordUpdateSuccessDialog extends StatelessWidget {
  const PasswordUpdateSuccessDialog({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (context) => PasswordUpdateSuccessDialog(
        onConfirm: onConfirm,
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
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.background,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Password Updated Successfully',
                style: AppTextStyle.text20SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Your account is now updated with the new password.',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.grey400,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Confirm',
                type: ButtonType.filled,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                width: double.infinity,
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
                borderRadius: 12.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

