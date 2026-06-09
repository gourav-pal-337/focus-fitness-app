import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class WhyFocusSection extends StatelessWidget {
  const WhyFocusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Elegant Header Section with verified icon & descriptive subtitle
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why Focus Fusion?',
                      style: AppTextStyle.text20SemiBold.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Your fitness journey, elevated by AI.',
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Benefit 1: AI Trainers Card
          const _BenefitItem(
            icon: Icons.psychology_outlined,
            title: 'Real Trainer Avatars',
            description:
                'Each avatar is based on a real personal trainer and is designed to respond in that trainer’s own coaching style.',
          ),

          SizedBox(height: AppSpacing.md),

          // Benefit 2: Free Access Previews Card
          const _BenefitItem(
            icon: Icons.bookmark_add_outlined,
            title: 'Free to Try',
            description:
                'For now, you can enjoy chatting with trainer avatars with no obligation. Booking and payment features with real trainers are coming soon.',
          ),

          SizedBox(height: AppSpacing.md),

          // Benefit 3: Amber / Caution styled Disclaimer Card
          const _BenefitItem(
            icon: Icons.gpp_maybe_outlined,
            title: 'General Guidance',
            description:
                'The avatar can help with general fitness guidance, motivation and reminders, but it does not replace professional, medical or emergency advice',
            isDisclaimer: true,
          ),

          SizedBox(height: AppSpacing.md),

          // General disclaimer Card
          const _BenefitItem(
            icon: Icons.info_outline_rounded,
            title: 'General disclaimer',
            description:
                'Focus Fusion provides general fitness support and trainer-style '
                'engagement between sessions. It does not replace your trainer or '
                'medical advice. It is designed for fitness-related support, not '
                'open-ended chat or non-fitness advice.',
            isDisclaimer: true,
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDisclaimer;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isDisclaimer = false,
  });

  @override
  Widget build(BuildContext context) {
    // Beautiful layered card colors depending on layout purpose
    final cardColor = isDisclaimer
        ? Colors.amber.withOpacity(0.06)
        : AppColors.grey75;

    final borderColor = isDisclaimer
        ? Colors.amber.withOpacity(0.25)
        : Colors.transparent;

    final iconBgColor = isDisclaimer
        ? Colors.amber.withOpacity(0.12)
        : AppColors.primary.withOpacity(0.1);

    final iconColor = isDisclaimer ? Colors.amber : AppColors.primary;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppRadius.large, // Sleek, modern rounded borders
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDisclaimer
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Container
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22.sp, color: iconColor),
          ),
          SizedBox(width: AppSpacing.md + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.text14SemiBold.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: AppTextStyle.text12Regular.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
