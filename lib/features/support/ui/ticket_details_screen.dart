import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Ticket Details',
             
              onBack: () {
                context.pop();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: AppSpacing.lg),
                    _TicketInfoSection(),
                    Divider(
                      color: AppColors.grey200,
                      thickness: 1,
                      height: 0,
                    ),
                    _ChatSupportSection(),
                    Divider(
                      color: AppColors.grey200,
                      thickness: 1,
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Processing Issue',
                      style: AppTextStyle.text16Medium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Ticket ID: #12345',
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Submitted on Dec 5, 2025 at 10:30 PM',
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8D5), // Light yellow
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'In Progress',
                  style: AppTextStyle.text12Regular.copyWith(
                    color: const Color(0xFFFBC02D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatSupportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(ChatSupportRoute.path);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.left,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            Text(
              'Chat support',
              style: AppTextStyle.text14SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}

