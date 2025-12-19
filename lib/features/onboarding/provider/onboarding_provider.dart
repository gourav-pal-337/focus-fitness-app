import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../core/constants/app_assets.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.imagePath,
    this.showPrimaryCta = false,
  });

  final String title;
  final String imagePath;
  final bool showPrimaryCta;
}

class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider()
      : pages = const <OnboardingPageData>[
          OnboardingPageData(
            title: 'Your Training.\nConnected.',
            imagePath: AppAssets.onboarding1,
          ),
          OnboardingPageData(
            title: 'Plans, Workouts &\nProgress',
            imagePath: AppAssets.onboarding2,
          ),
          OnboardingPageData(
            title: '',
            imagePath: AppAssets.onboarding3,
            showPrimaryCta: true,
          ),
        ];

  final PageController pageController = PageController();

  final List<OnboardingPageData> pages;

  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> goToNext() async {
    if (currentPage < pages.length - 1) {
      await pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // TODO: Navigate to auth/signup flow using go_router.
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}


