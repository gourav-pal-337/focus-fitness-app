import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// A reusable skeleton loader widget with shimmer animation
/// Can be used to show loading states for various UI elements
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.child,
  });

  /// Width of the skeleton. If null, takes full available width
  final double? width;

  /// Height of the skeleton
  final double? height;

  /// Border radius of the skeleton
  final BorderRadius? borderRadius;

  /// Base color for the skeleton (darker)
  final Color? baseColor;

  /// Highlight color for the shimmer effect (lighter)
  final Color? highlightColor;

  /// Optional child widget. If provided, skeleton will wrap around it
  /// Useful for creating complex skeleton layouts
  final Widget? child;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.grey400.withValues(alpha: 0.7);
    final highlightColor = widget.highlightColor ?? AppColors.grey300.withValues(alpha: 0.7);
    final borderRadius = widget.borderRadius ?? BorderRadius.zero;

    if (widget.child != null) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              final progress = _controller.value;
              final gradientStart = -1.0 + (progress * 2.0);
              final gradientEnd = gradientStart + 0.6;

              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  baseColor,
                  baseColor,
                  highlightColor,
                  baseColor,
                  baseColor,
                ],
                stops: [
                  0.0,
                  (gradientStart.clamp(0.0, 1.0) - 0.1).clamp(0.0, 1.0),
                  gradientStart.clamp(0.0, 1.0),
                  gradientEnd.clamp(0.0, 1.0),
                  1.0,
                ],
              ).createShader(bounds);
            },
            child: widget.child,
          );
        },
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final gradientStart = -1.0 + (progress * 2.0);
        final gradientEnd = gradientStart + 0.6;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                baseColor,
                highlightColor,
                baseColor,
                baseColor,
              ],
              stops: [
                0.0,
                (gradientStart.clamp(0.0, 1.0) - 0.1).clamp(0.0, 1.0),
                gradientStart.clamp(0.0, 1.0),
                gradientEnd.clamp(0.0, 1.0),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton for circular avatars
class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({
    super.key,
    required this.radius,
    this.baseColor,
    this.highlightColor,
  });

  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: radius * 2,
      height: radius * 2,
      borderRadius: BorderRadius.circular(radius),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

/// Pre-built skeleton for text lines
class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width ?? double.infinity,
      height: height ?? 16.h,
      borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

/// Pre-built skeleton for rectangular containers
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius ?? AppRadius.small,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

