import 'package:flutter/material.dart';

import '../responsive/responsive_config.dart';
import '../theme/app_colors.dart';

/// Drop-in replacement for [showModalBottomSheet] that adapts to the screen.
///
/// On phones it behaves exactly like [showModalBottomSheet] (a bottom-anchored
/// sheet). On tablets / iPad a full-width bottom-anchored sheet looks awkward,
/// so the same [builder] content is instead presented as a centered, floating
/// card (rounded on all corners) — see [_CenteredSheetCard].
Future<T?> showAppModalSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  Color? backgroundColor,
}) {
  final size = MediaQuery.of(context).size;

  if (!ResponsiveConfig.isTablet(size)) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      backgroundColor: backgroundColor ?? Colors.transparent,
      builder: builder,
    );
  }

  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) => _CenteredSheetCard(
      backgroundColor: backgroundColor,
      builder: builder,
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// The tablet presentation of a modal sheet: the sheet [builder] content,
/// clipped to an all-corners-rounded card and centered on screen. Lifts above
/// the keyboard when one is open.
class _CenteredSheetCard extends StatelessWidget {
  const _CenteredSheetCard({required this.builder, this.backgroundColor});

  final WidgetBuilder builder;
  final Color? backgroundColor;

  /// Widest the floating card is allowed to grow on a tablet.
  static const double _maxCardWidth = 560;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cardColor =
        (backgroundColor == null || backgroundColor == Colors.transparent)
            ? AppColors.background
            : backgroundColor!;

    return Padding(
      // Keep the card above the on-screen keyboard.
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _maxCardWidth,
              maxHeight: mq.size.height - 48,
            ),
            child: Material(
              color: cardColor,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(20),
              child: builder(context),
            ),
          ),
        ),
      ),
    );
  }
}
