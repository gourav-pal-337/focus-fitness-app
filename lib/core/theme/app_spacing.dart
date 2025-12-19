import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppSpacing {
  static double xs = 4.w;
  static double sm = 8.w;
  static double md = 16.w;
  static double lg = 24.w;
  static double xl = 32.w;

  static EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
}


