// import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AutoSystemUIWrapper extends StatelessWidget {
  final Widget child;
  final Color headerColor;

  const AutoSystemUIWrapper({
    super.key,
    required this.child,
    required this.headerColor,
  });

  bool _isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkHeader = _isDark(headerColor);
    debugPrint("headerColor: $headerColor");
    debugPrint("isDarkHeader: $isDarkHeader");

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: headerColor,
        systemNavigationBarIconBrightness: isDarkHeader
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: headerColor,
        statusBarIconBrightness: isDarkHeader
            ? Brightness.light
            : Brightness.dark,
      ),
      child: child,
    );
  }
}
