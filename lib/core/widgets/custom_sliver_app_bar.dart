import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.title,
    required this.backgroundImage,
    this.expandedHeight,
    this.onBack,
    this.showBackButton = true,
    this.actions,
    this.centerTitle = false,
    this.titlePadding,
    this.gradientColors,
  });

  final String title;
  final String backgroundImage;
  final double? expandedHeight;
  final VoidCallback? onBack;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool centerTitle;
  final EdgeInsets? titlePadding;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    var size  = MediaQuery.of(context).size;
    final leadingWidth = showBackButton ? size.width * 0.7 : 0;
    return SliverAppBar(
      expandedHeight: expandedHeight ?? 200.h,
      floating: false,
      // pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: leadingWidth.toDouble(),
      leading: showBackButton
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
                child: GestureDetector(
                  onTap: onBack ?? () => context.pop(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 24.sp,
                        color: AppColors.background,
                      ),
                      SizedBox(width: AppSpacing.lg),
                     Text(
          title,
          style: AppTextStyle.text20SemiBold.copyWith(
            color: AppColors.background,
          ),
        ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      actions: actions != null
          ? [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(right: AppSpacing.screenPadding.right),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
              ),
            ]
          : null,
      flexibleSpace: FlexibleSpaceBar(
       
        centerTitle: centerTitle,
        titlePadding: titlePadding ??
            EdgeInsets.only(
              left: showBackButton
                  ? AppSpacing.screenPadding.left + 32.w
                  : AppSpacing.screenPadding.left,
              bottom: AppSpacing.md,
            ),
        background: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                backgroundImage,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors ??
                        [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

