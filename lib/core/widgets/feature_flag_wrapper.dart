import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'feature_disabled_widget.dart';
import 'buttons/custom_bottom.dart';
import '../../routes/app_router.dart';

class FeatureFlagWrapper extends StatelessWidget {
  final Widget child;
  final bool isEnabled;
  final String title;
  final String message;
  final IconData icon;

  const FeatureFlagWrapper({
    super.key,
    required this.child,
    required this.isEnabled,
    this.title = 'Coming Soon',
    this.message = 'This feature is under maintenance. Please check back later.',
    this.icon = Icons.construction,
  });

  @override
  Widget build(BuildContext context) {
    if (isEnabled) return child;

    return Stack(
      children: [
        // The background content remains visible but non-interactive
        IgnorePointer(child: child),
        // Overlay with blur effect
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.2),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ).copyWith(top: MediaQuery.of(context).padding.top + 6.h),
                    padding: EdgeInsets.all(AppSpacing.xl),
                    constraints: BoxConstraints(maxWidth: 320.w),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(32.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FeatureDisabledWidget(
                          title: title,
                          message: message,
                          icon: icon,
                        ),
                        SizedBox(height: AppSpacing.xl),
                        CustomButton(
                          text: 'Go Back',
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(HomeRoute.path);
                            }
                          },
                          width: double.infinity,
                          borderRadius: 16.r,
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.background,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
