import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/theme/app_colors.dart';
import 'package:focus_fitness/core/theme/app_text_styles.dart';
// import 'package:travel_rumours/constants/app_colors.dart';
// import 'package:travel_rumours/constants/app_styles.dart';

enum ButtonType {
  filled,
  outlined,
  text,
  gradient,
}

enum ButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonType type;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? icon;
  final IconPosition iconPosition;
  final double? width;
  final double? height;
  final List<Color>? gradientColors;
  final Alignment? gradientBegin;
  final Alignment? gradientEnd;
  final double? elevation;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final Duration? loadingDuration;
  final Widget? loadingWidget;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.type = ButtonType.filled,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.elevation,
    this.shadowColor,
    this.textStyle,
    this.loadingDuration,
    this.loadingWidget,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

enum IconPosition { left, right }

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin,
            width: widget.width,
            height: widget.height ?? _getButtonHeight(),
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: _handleTap,
              child: _buildButton(),
            ),
          ),
        );
      },
    );
  }

  void _handleTap() {
    if (widget.isEnabled && !widget.isLoading && widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  Widget _buildButton() {
    switch (widget.type) {
      case ButtonType.filled:
        return _buildFilledButton();
      case ButtonType.outlined:
        return _buildOutlinedButton();
      case ButtonType.text:
        return _buildTextButton();
      case ButtonType.gradient:
        return _buildGradientButton();
    }
  }

  Widget _buildFilledButton() {
    return Container(
      decoration: BoxDecoration(
        color: widget.isEnabled && !widget.isLoading
            ? widget.backgroundColor ?? _getDefaultBackgroundColor()
            : (widget.backgroundColor ?? _getDefaultBackgroundColor()).withOpacity(0.5),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? _getDefaultBorderRadius()),
        boxShadow: widget.elevation != null && widget.elevation! > 0
            ? [
                BoxShadow(
                  color: (widget.shadowColor ?? widget.backgroundColor ?? _getDefaultBackgroundColor())
                      .withOpacity(0.3),
                  blurRadius: widget.elevation!,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? _getDefaultBorderRadius()),
        border: Border.all(
          color: widget.isEnabled && !widget.isLoading
              ? widget.borderColor ?? widget.backgroundColor ?? _getDefaultBackgroundColor()
              : (widget.borderColor ?? widget.backgroundColor ?? _getDefaultBackgroundColor()).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? _getDefaultBorderRadius()),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.isEnabled && !widget.isLoading
            ? LinearGradient(
                colors: widget.gradientColors ?? _getDefaultGradientColors(),
                begin: widget.gradientBegin ?? Alignment.centerLeft,
                end: widget.gradientEnd ?? Alignment.centerRight,
              )
            : LinearGradient(
                colors: (widget.gradientColors ?? _getDefaultGradientColors())
                    .map((color) => color.withOpacity(0.5))
                    .toList(),
                begin: widget.gradientBegin ?? Alignment.centerLeft,
                end: widget.gradientEnd ?? Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? _getDefaultBorderRadius()),
        boxShadow: widget.elevation != null && widget.elevation! > 0
            ? [
                BoxShadow(
                  color: (widget.shadowColor ?? widget.gradientColors?.first ?? _getDefaultGradientColors().first)
                      .withOpacity(0.3),
                  blurRadius: widget.elevation!,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    return Container(
      padding: widget.padding ?? _getDefaultPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null && widget.iconPosition == IconPosition.left) ...[
            widget.icon!,
             SizedBox(width: 8.w),
          ],
          if (widget.isLoading)
            _buildLoadingWidget()
          else
            _buildText(),
          if (widget.icon != null && widget.iconPosition == IconPosition.right) ...[
            SizedBox(width: 8.w),
            widget.icon!,
          ],
        ],
      ),
    );
  }

  Widget _buildText() {
    return Text(
      widget.text,
      style: widget.textStyle ?? _getDefaultTextStyle(),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return SizedBox(
      width: _getLoadingSize(),
      height: _getLoadingSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.textColor ?? _getDefaultTextColor(),
        ),
      ),
    );
  }

  // Helper methods for default values
  double _getButtonHeight() {
    switch (widget.size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
      case ButtonSize.extraLarge:
        return 64;
    }
  }

  EdgeInsets _getDefaultPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 5);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 5);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 5);
      case ButtonSize.extraLarge:
        return const EdgeInsets.symmetric(horizontal: 40, vertical: 5);
    }
  }

  double _getDefaultBorderRadius() {
    switch (widget.size) {
      case ButtonSize.small:
        return 4;
      case ButtonSize.medium:
        return 4;
      case ButtonSize.large:
        return 4;
      case ButtonSize.extraLarge:
        return 4;
    }
  }

  Color _getDefaultBackgroundColor() {
    return  AppColors.primary;
  }

  Color _getDefaultTextColor() {
    switch (widget.type) {
      case ButtonType.filled:
      case ButtonType.gradient:
        return Colors.white;
      case ButtonType.outlined:
      case ButtonType.text:
        return widget.backgroundColor ?? _getDefaultBackgroundColor();
    }
  }

  List<Color> _getDefaultGradientColors() {
    return [
       AppColors.primary,
     AppColors.primary
    ];
  }

  TextStyle _getDefaultTextStyle() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTextStyle.text14Bold.copyWith(
          color: widget.textColor ?? _getDefaultTextColor(),
        );
      case ButtonSize.medium:
        return AppTextStyle.text16Bold.copyWith(
          color: widget.textColor ?? _getDefaultTextColor(),
        );
      case ButtonSize.large:
        return AppTextStyle.text18Bold.copyWith(
          color: widget.textColor ?? _getDefaultTextColor(),
        );
      case ButtonSize.extraLarge:
        return AppTextStyle.text20Bold.copyWith(
          color: widget.textColor ?? _getDefaultTextColor(),
        );
    }
  }

  double _getLoadingSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
      case ButtonSize.extraLarge:
        return 28;
    }
  }
}