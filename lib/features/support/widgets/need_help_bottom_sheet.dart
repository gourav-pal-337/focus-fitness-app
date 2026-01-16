import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'support_option_item.dart';

class NeedHelpBottomSheet extends StatelessWidget {
  const NeedHelpBottomSheet({
    super.key,
    required this.onFAQsTap,
    required this.onContactSupportTap,
    required this.onBillingSubscriptionsTap,
    required this.onTrackTicketStatusTap,
  });

  final VoidCallback onFAQsTap;
  final VoidCallback onContactSupportTap;
  final VoidCallback onBillingSubscriptionsTap;
  final VoidCallback onTrackTicketStatusTap;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onFAQsTap,
    required VoidCallback onContactSupportTap,
    required VoidCallback onBillingSubscriptionsTap,
    required VoidCallback onTrackTicketStatusTap,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NeedHelpBottomSheet(
        onFAQsTap: onFAQsTap,
        onContactSupportTap: onContactSupportTap,
        onBillingSubscriptionsTap: onBillingSubscriptionsTap,
        onTrackTicketStatusTap: onTrackTicketStatusTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.left),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Icon(
                     Icons.close,
                     size: 24.sp,
                     color: Colors.transparent,
                   ),
                  Text(
                    'Need Help?',
                    style: AppTextStyle.text24Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'We\'re here for you!\nIf you\'re facing an issue or have a question, just reach out and our support team will get back to you ASAP.',
                style: AppTextStyle.text12Regular.copyWith(
                  color: AppColors.grey400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              SupportOptionItem(
                icon: Icons.help_outline,
                title: 'FAQs',
                description: 'View frequently asked questions',
                onTap: () {
                  Navigator.of(context).pop();
                  onFAQsTap();
                },
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              SupportOptionItem(
                icon: Icons.add_comment,
                title: 'Contact Support',
                description: 'Create Support Ticket',
                onTap: () {
                  Navigator.of(context).pop();
                  onContactSupportTap();
                },
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              SupportOptionItem(
                icon: Icons.receipt_long_outlined,
                title: 'Billing & Subscriptions',
                description: 'Billing & subscription settings.',
                onTap: () {
                  Navigator.of(context).pop();
                  onBillingSubscriptionsTap();
                },
              ),
              Divider(
                color: AppColors.grey200,
                thickness: 1,
                height: 0,
              ),
              SupportOptionItem(
                icon: Icons.check_circle_outline,
                title: 'Track Ticket Status',
                description: 'Track your ticket status here.',
                onTap: () {
                  Navigator.of(context).pop();
                  onTrackTicketStatusTap();
                },
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

