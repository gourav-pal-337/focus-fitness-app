import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(PasswordInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // vertical: 10.h,
        horizontal: AppSpacing.screenPadding.left,
      ).copyWith(bottom: 5.h,top: 15.h),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        obscureText: _obscureText,
        style: AppTextStyle.text16Regular.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          // contentPadding: EdgeInsets.zero,
          isDense: true,
          hintText: widget.label,
          hintStyle: AppTextStyle.text16Regular.copyWith(
            color: AppColors.grey400,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.w),
              child: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 15.sp,
                color: AppColors.grey400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

