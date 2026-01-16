import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.showBackButton = true,
    this.actions,
    this.centerTitle = false,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBack ?? () => context.pop(),
                  child: Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.text20SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
        Container(
              height: 1.h,
              color: AppColors.grey200,
            ),
      ],
    );
  }
}

