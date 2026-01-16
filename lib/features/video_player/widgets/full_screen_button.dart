import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class FullScreenButton extends StatelessWidget {
  const FullScreenButton({
    super.key,
    required this.isFullscreen,
    required this.onPressed,
  });

  final bool isFullscreen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Icon(
          isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
          size: 24.sp,
          color: AppColors.background,
        ),
      ),
    );
  }
}

