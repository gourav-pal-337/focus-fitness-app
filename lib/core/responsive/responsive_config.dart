import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Centralised responsive behaviour for the app.
///
/// The UI is authored against a phone canvas (375x812). Left unhandled, on a
/// tablet / iPad `flutter_screenutil` derives its scale factor from the real
/// device size (`screenSize / designSize`), which on an iPad is ~2x and blows
/// the layout up. Instead of capping the reported screen size (which would
/// hide the real device width from widgets that need it), we clamp the
/// ScreenUtil scale factor on large screens via [designSizeFor].
class ResponsiveConfig {
  ResponsiveConfig._();

  /// The design canvas the UI was built against.
  static const Size phoneDesignSize = Size(375, 812);

  /// The largest scale factor `flutter_screenutil` is allowed to apply. Phones
  /// scale normally (≈1.0–1.2x); tablets/iPad are clamped here so the phone
  /// design enlarges by at most this factor instead of ~2x.
  static const double maxTabletScale = 1.35;

  /// A device is treated as a tablet (iPad) once its shortest side is large.
  static bool isTablet(Size size) => size.shortestSide >= 600;

  /// The `designSize` to feed `ScreenUtilInit` for the current screen.
  ///
  /// `flutter_screenutil` scale = `screenSize / designSize`. To cap the
  /// effective scale at [maxTabletScale] on large screens we widen the design
  /// size: `designW = max(375, screenW / 1.35)` (and likewise for height). For
  /// phones the `max` keeps the design at 375x812 so they scale normally; for
  /// tablets it pins both axes to a 1.35x scale.
  static Size designSizeFor(Size screenSize) {
    final width = screenSize.width;
    final height = screenSize.height;
    if (width <= 0 || height <= 0) return phoneDesignSize;
    final designWidth = math.max(phoneDesignSize.width, width / maxTabletScale);
    final designHeight =
        math.max(phoneDesignSize.height, height / maxTabletScale);
    return Size(designWidth, designHeight);
  }

  /// Width a side drawer should occupy: a fixed 400 on tablets (so it doesn't
  /// span the whole iPad), otherwise the usual phone proportion of the screen.
  static double drawerWidth(Size size) =>
      isTablet(size) ? 400 : size.width * 0.85;
}
