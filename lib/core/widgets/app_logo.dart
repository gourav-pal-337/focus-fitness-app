import 'package:flutter/widgets.dart';

import '../constants/app_assets.dart';
import '../theme/app_spacing.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: width ?? AppSpacing.lg * 6,
      height: height,
      fit: BoxFit.contain,
    );
  }
}


