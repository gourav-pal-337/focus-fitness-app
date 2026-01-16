import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:focus_fitness/core/theme/app_colors.dart';
import 'package:focus_fitness/core/theme/app_radius.dart';
import 'package:focus_fitness/core/theme/app_spacing.dart';
import 'package:focus_fitness/core/theme/app_text_styles.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.enabledBorderColor,
    this.focusedBorderColor,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int maxLines;
  final bool? enabled;

  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle =
        textStyle ?? AppTextStyle.text16Regular.copyWith(color: AppColors.textPrimary);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      style: baseTextStyle,
      cursorColor: AppColors.primary,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
            AppTextStyle.text16Regular.copyWith(
              color: AppColors.grey100.withOpacity(0.7),
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(
            color: enabledBorderColor ?? AppColors.grey100,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.primary,
            width: 1.2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14.h,
        ),
      ),
    );
  }
}

