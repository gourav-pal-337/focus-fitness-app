import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';
import '../data/models/ticket_model.dart';

class TicketDetailsScreen extends StatelessWidget {
  final TicketModel? ticket;
  const TicketDetailsScreen({super.key, this.ticket});

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
                    _TicketInfoSection(ticket: ticket),
                    Divider(color: AppColors.grey200, thickness: 1, height: 0),
                    // _ChatSupportSection(),
                    // Divider(color: AppColors.grey200, thickness: 1, height: 0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.left),
              child: CustomButton(
                text: 'Okay',
                onPressed: () {
                  context.go(HomeRoute.path);
                },
                width: double.infinity,
                borderRadius: 12.r,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _TicketInfoSection extends StatelessWidget {
  final TicketModel? ticket;
  const _TicketInfoSection({this.ticket});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (ticket?.createdAt != null) {
      try {
        final date = DateTime.parse(ticket!.createdAt!).toLocal();
        formattedDate = DateFormat('MMM d, yyyy').format(date);
        final time = DateFormat('hh:mm a').format(date);
        formattedDate = 'Submitted on $formattedDate at $time';
      } catch (e) {
        formattedDate = ticket!.createdAt!;
      }
    }

    Color badgeBgColor;
    Color badgeTextColor;
    String displayStatus = ticket?.status ?? 'Unknown';

    final status = ticket?.status?.toLowerCase() ?? '';
    if (status == 'open') {
      displayStatus = 'Open';
      badgeBgColor = const Color(0xFFE1F5FE);
      badgeTextColor = const Color(0xFF29B6F6);
    } else if (status == 'in_progress') {
      displayStatus = 'In Progress';
      badgeBgColor = const Color(
        0xFFEFE8D5,
      ); // Using your light yellow from screenshot
      badgeTextColor = const Color(0xFFFBC02D);
    } else if (status == 'resolved') {
      displayStatus = 'Resolved';
      badgeBgColor = const Color(0xFFE8F5E9);
      badgeTextColor = const Color(0xFF4CAF50);
    } else if (status == 'closed') {
      displayStatus = 'Closed';
      badgeBgColor = const Color(0xFFE8F5E9);
      badgeTextColor = const Color(0xFF4CAF50);
    } else {
      badgeBgColor = AppColors.grey200;
      badgeTextColor = AppColors.grey500;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket?.title ?? 'No Subject',
                      style: AppTextStyle.text16Medium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Ticket ID: #${ticket?.id ?? "N/A"}',
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      formattedDate,
                      style: AppTextStyle.text12Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  displayStatus,
                  style: AppTextStyle.text12Regular.copyWith(
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          if (ticket?.description != null &&
              ticket!.description!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.lg),
            Text(
              'Description',
              style: AppTextStyle.text14SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              ticket!.description!,
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
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
            Icon(Icons.chevron_right, size: 24.sp, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
