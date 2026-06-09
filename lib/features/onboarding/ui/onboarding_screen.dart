import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/app_modal_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';
import '../../../core/service/local_storage_service.dart';
import '../widgets/onboarding_controls.dart';
import '../../../core/widgets/why_focus_section.dart';

class OnboardingPageModel {
  final String title;
  final String description;
  final String imagePath;
  final bool isLast;
  final String? disclaimer;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLast = false,
    this.disclaimer,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isReturningUser = false;

  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      title: 'Welcome to\nFocus Fusion',
      description: 'Chat with AI fitness avatars based on real personal trainers. Choose from different backgrounds, areas of expertise and coaching styles. Ask questions, get tips and stay motivated.',
      imagePath: AppAssets.onboarding1,
    ),
    OnboardingPageModel(
      title: 'Real Trainer\nAvatars',
      description: 'Each avatar is based on a real personal trainer and is designed to respond in that trainer’s own coaching style.',
      imagePath: AppAssets.onboarding2,
    ),
    OnboardingPageModel(
      title: 'Free to Try',
      description: 'For now, you can enjoy chatting with trainer avatars with no obligation. Booking and payment features with real trainers are coming soon.',
      imagePath: AppAssets.onboarding3,
      isLast: true,
      disclaimer: 'The avatar can help with general fitness guidance, motivation and reminders, but it does not replace professional, medical or emergency advice',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final bool? completed = await LocalStorageService.getOnboarding();
      if (completed == true) {
        setState(() {
          _isReturningUser = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading onboarding status: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReturningUser) {
      return _buildReturningUserLayout();
    }

    final bool isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // 1. PageView sliding builder
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) async {
              setState(() {
                _currentPage = index;
              });
              // Persistently save onboarding completion if last page reached
              if (index == _pages.length - 1) {
                await LocalStorageService.setOnboarding(true);
              }
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingSlide(
                key: ValueKey(_pages[index].title), // Forces fresh mount animation on swipe
                page: _pages[index],
              );
            },
          ),
          
          // 2. Fixed overlay controls area at the bottom
          Positioned(
            bottom: 15.h,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.left,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLastPage
                      ? _buildLastPageCta()
                      : _buildNavigationControls(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Row(
      key: const ValueKey('navigation'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OnboardingPageIndicator(
          itemCount: _pages.length,
          currentIndex: _currentPage,
        ),
        OnboardingNextButton(
          onPressed: () async {
            final nextPage = _currentPage + 1;
            await _pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
            );
            if (nextPage == _pages.length - 1) {
              await LocalStorageService.setOnboarding(true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildLastPageCta() {
    return Column(
      key: const ValueKey('cta'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          text: 'Sign up with Email',
          size: ButtonSize.large,
          width: double.infinity,
          height: 52.h,
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
          icon: Icon(
            Icons.mail_outline,
            size: 20.sp,
            color: AppColors.background,
          ),
          textStyle: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.background,
          ),
          borderRadius: 12.r,
          onPressed: () {
            context.push(EnterNameRoute.path);
          },
        ),
        SizedBox(height: AppSpacing.sm + 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey100,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(LoginWithEmailRoute.path);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign In',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReturningUserLayout() {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Premium cover background matching onboarding Slide 3
          const AppImage(
            path: AppAssets.onboarding3,
            fit: BoxFit.cover,
          ),
          // Original onboarding gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.onboardingOverlay,
            ),
          ),
          
          // 2. High-Fidelity UI Layout
          SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Brand Header (Consistent with original OnboardingPage)
                  Center(
                    child: Text(
                      'FOCUS FUSION',
                      style: AppTextStyle.text32Medium.copyWith(
                        color: AppColors.background,
                        letterSpacing: 2.sp,
                      ),
                    ),
                  ),
                  const Spacer(), // Pushes welcome content beautifully to the bottom-left!
                  
                  // Welcome Header (Consistent with Onboarding title typography)
                  Text(
                    'Welcome to\nFocus Fusion',
                    style: AppTextStyle.text32SemiBold.copyWith(
                      color: AppColors.background,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  
                  // Welcome Description
                  Text(
                    'Chat with AI fitness avatars based on real personal trainers. Choose from different backgrounds, areas of expertise and coaching styles. Ask questions, get tips and stay motivated.',
                    style: AppTextStyle.text14Medium.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      height: 1.5,
                    ),
                  ),
                  
                  // View Details Toggle Button (Bottom-left aligned)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: _buildDetailsToggle(),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  
                  // Bottom CTA Area
                  _buildLastPageCta(),
                  SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsToggle() {
    return TextButton(
      onPressed: () {
        showAppModalSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const _WhyFocusBottomSheetWrapper(),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'View Details',
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _WhyFocusBottomSheetWrapper extends StatelessWidget {
  const _WhyFocusBottomSheetWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Elegant drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          const WhyFocusSection(),
        ],
      ),
    );
  }
}

class OnboardingSlide extends StatefulWidget {
  final OnboardingPageModel page;

  const OnboardingSlide({super.key, required this.page});

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleFade;
  late Animation<double> _descFade;
  late Animation<double> _disclaimerFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _descFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _disclaimerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection({
    required Animation<double> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Premium cover background matching the onboarding style
        AppImage(
          path: widget.page.imagePath,
          fit: BoxFit.cover,
        ),
        // Original onboarding gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.onboardingOverlay,
          ),
        ),
        
        // 2. Content Layout
        SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Brand Header
                Center(
                  child: Text(
                    'FOCUS FUSION',
                    style: AppTextStyle.text32Medium.copyWith(
                      color: AppColors.background,
                      letterSpacing: 2.sp,
                    ),
                  ),
                ),
                const Spacer(),
                
                // Title
                _buildAnimatedSection(
                  animation: _titleFade,
                  child: Text(
                    widget.page.title,
                    style: AppTextStyle.text32SemiBold.copyWith(
                      color: AppColors.background,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                
                // Description
                _buildAnimatedSection(
                  animation: _descFade,
                  child: Text(
                    widget.page.description,
                    style: AppTextStyle.text14Medium.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      height: 1.5,
                    ),
                  ),
                ),
                
                // Disclaimer (If applicable)
                if (widget.page.disclaimer != null) ...[
                  SizedBox(height: AppSpacing.md + 4),
                  _buildAnimatedSection(
                    animation: _disclaimerFade,
                    child: _buildDisclaimerItem(
                      icon: Icons.gpp_maybe_outlined,
                      text: widget.page.disclaimer!,
                    ),
                  ),
                ],
                
                SizedBox(height: widget.page.isLast ? 100.h : 80.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerItem({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 20.sp),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.text14Medium.copyWith(
                fontSize: 13.sp,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
