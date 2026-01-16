import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_fitness/core/constants/app_assets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';

class TicketSuccessScreen extends StatelessWidget {
  const TicketSuccessScreen({
    super.key,
    this.ticketId,
  });

  final String? ticketId;

  @override
  Widget build(BuildContext context) {
    final displayTicketId = ticketId ?? '#48291';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Contact Support',
              onBack: () {
                context.pop();
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   SizedBox(
      width: 120.w,
      height: 120.w,
      child: 
        SvgPicture.asset(AppAssets.supportIcon),
    ),
                    SizedBox(height: AppSpacing.xl),
                    Text(
                      'Your ticket has been raised $displayTicketId',
                      style: AppTextStyle.text16SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Thank you for contacting us. Our support team will get back to you soon.',
                      style: AppTextStyle.text14Medium.copyWith(
                        color: AppColors.grey400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomButton(
            text: 'View Ticket',
            type: ButtonType.filled,
            onPressed: () {
              context.push(TicketDetailsRoute.path);
            },
            width: double.infinity,
            backgroundColor: AppColors.primary,
            textColor: AppColors.background,
            borderRadius: 12.r,
            textStyle: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.background,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: () {
              // Pop back to contact support screen
              context.pop();
            },
            child: Text(
              'Raise another issue',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

