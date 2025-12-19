import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../provider/onboarding_provider.dart';
import '../widgets/onboarding_controls.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, _) {
        final bool isLastPage =
            provider.currentPage == provider.pages.length - 1;

        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: provider.pageController,
                onPageChanged: provider.onPageChanged,
                itemCount: provider.pages.length,
                itemBuilder: (context, index) {
                  final page = provider.pages[index];
                  return OnboardingPage(
                    title: page.title,
                    imagePath: page.imagePath,
                    showPrimaryCta: page.showPrimaryCta,
                  );
                },
              ),
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,

                              child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.screenPadding.left,
                      right: AppSpacing.screenPadding.right,
                      bottom: AppSpacing.md,
                    ),
                    child: isLastPage
                        ? OnboardingPrimaryCta()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OnboardingPageIndicator(
                                itemCount: provider.pages.length,
                                currentIndex: provider.currentPage,
                              ),
                              OnboardingNextButton(
                                onPressed: provider.goToNext,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
