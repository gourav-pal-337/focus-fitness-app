import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:focus_fitness/core/service/local_storage_service.dart';

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
  bool _isInitialized = false;

  /// Initialize onboarding provider by checking onboarding status
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final onboardingCompleted = await LocalStorageService.getOnboarding();
      
      // If onboarding is already completed, start from the last page
      if (onboardingCompleted == true) {
        currentPage = pages.length - 1;
        // Jump to last page without animation
        if (pageController.hasClients) {
          pageController.jumpToPage(currentPage);
        }
      } else {
        // Start from first page
        currentPage = 0;
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing onboarding: $e');
      // Default to first page on error
      currentPage = 0;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> goToNext() async {
    if (currentPage < pages.length - 1) {
      final nextPage = currentPage + 1;
      await pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      currentPage = nextPage;
      notifyListeners();
      
      // If we've reached the last page, mark onboarding as completed
      if (currentPage == pages.length - 1) {
        await LocalStorageService.setOnboarding(true);
        debugPrint("onboarding set to true");
      }
    } else {
      // Already on last page, onboarding should be completed
      await LocalStorageService.setOnboarding(true);
      debugPrint("onboarding set to true");
      // TODO: Navigate to auth/signup flow using go_router.
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}


