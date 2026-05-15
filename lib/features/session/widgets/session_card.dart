import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/show_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../core/provider/app_features_provider.dart';
import '../../../core/utils/feature_flag_utils.dart';
import 'session_status_badge.dart';
import 'session_action_buttons.dart';
import 'invoice_button.dart';

import '../data/models/booking_model.dart';

enum SessionStatus { cancelled, completed, upcoming }

class SessionData {
  final String trainerName;
  final String trainerImageUrl;
  final String sessionType;
  final String duration;
  final SessionStatus status;
  final String date;
  final String? startTime;
  final String? invoiceUrl;
  final String? bookingId;
  final BookingModel? booking;

  SessionData({
    required this.trainerName,
    required this.trainerImageUrl,
    required this.sessionType,
    required this.duration,
    required this.status,
    required this.date,
    this.startTime,
    this.invoiceUrl,
    this.bookingId,
    this.booking,
  });
}

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});

  final SessionData session;

  @override
  Widget build(BuildContext context) {
    final features = context.watch<AppFeaturesProvider>();

    return GestureDetector(
      onTap: () {
        if (features.isSessionSummariesEnabled) {
          context.push(SessionDetailsRoute.path, extra: session);
        } else {
          FeatureFlagUtils.showFeatureDisabledBottomSheet(
            context,
            title: 'Summaries Disabled',
            message: 'Session details and summaries are currently unavailable.',
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.medium,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey400.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowImage(
                  imageUrl: session.trainerImageUrl,
                  width: 60.r,
                  height: 60.r,
                  isCircle: true,
                  errorWidget: Icon(
                    Icons.person,
                    size: 24.sp,
                    color: AppColors.grey400,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.trainerName,
                        style: AppTextStyle.text16SemiBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      // SizedBox(height: 2.h),
                      Text(
                        '${session.sessionType} • ${session.duration}',
                        style: AppTextStyle.text12Medium.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SessionStatusBadge(status: session.status),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            '${session.date}${session.startTime != null ? ' • ${session.startTime}' : ''}',
                            style: AppTextStyle.text12Medium.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (session.invoiceUrl != null &&
                session.invoiceUrl!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.lg),
              InvoiceButton(invoiceUrl: session.invoiceUrl!),
            ],
            if (session.status == SessionStatus.completed &&
                session.booking?.feedback == null &&
                features.isRatingFeedbackEnabled) ...[
              SizedBox(height: AppSpacing.lg),
              SessionActionButtons(session: session),
            ],
          ],
        ),
      ),
    );
  }
}
