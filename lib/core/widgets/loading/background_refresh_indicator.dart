import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

class BackgroundRefreshIndicator extends StatelessWidget {
  const BackgroundRefreshIndicator({
    super.key,
    required this.isRefreshing,
    this.padding,
  });

  final bool isRefreshing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isRefreshing
          ? Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w),
              child: SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withOpacity(0.8),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
