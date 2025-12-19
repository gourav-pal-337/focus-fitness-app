import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppGradients {
  static const LinearGradient onboardingOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.overlayDark05,
      AppColors.overlayDark20,
      AppColors.overlayDark80,
      AppColors.overlayDark100,
    ],
    stops: <double>[
      0.0,
      0.35,
      0.7,
      1.0,
    ],
  );
}


