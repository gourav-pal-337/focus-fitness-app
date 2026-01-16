import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'buttons/custom_bottom.dart';

class CustomInfoDialog extends StatelessWidget {
  const CustomInfoDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    this.titleStyle,
    this.messageStyle,
    this.buttonColor,
  });

  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final Color? buttonColor;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onButtonPressed,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    Color? buttonColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (context) => CustomInfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
        buttonColor: buttonColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.horizontal,
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
              Text(
                title,
                style: titleStyle ??
                    AppTextStyle.text24SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: messageStyle ??
                    AppTextStyle.text14Regular.copyWith(
                      color: AppColors.grey400,
                      height: 1.2,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: buttonText,
                type: ButtonType.filled,
                onPressed: () {
                  Navigator.of(context).pop();
                  onButtonPressed();
                },
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                width: double.infinity,
                backgroundColor: buttonColor ?? AppColors.primary,
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

