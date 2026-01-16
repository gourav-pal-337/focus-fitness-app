import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({
    super.key,
    required this.isMuted,
    required this.onPressed,
  });

  final bool isMuted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Icon(
          isMuted ? Icons.volume_off : Icons.volume_up,
          size: 24.sp,
          color: AppColors.background,
        ),
      ),
    );
  }
}

