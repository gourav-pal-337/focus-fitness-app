import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import 'session_status_badge.dart';
import 'session_action_buttons.dart';
import 'invoice_button.dart';

enum SessionStatus { cancelled, completed, upcoming }

class SessionData {
  final String trainerName;
  final String trainerImageUrl;
  final String sessionType;
  final String duration;
  final SessionStatus status;
  final String date;
  final String? invoiceUrl;
  final String? bookingId;

  SessionData({
    required this.trainerName,
    required this.trainerImageUrl,
    required this.sessionType,
    required this.duration,
    required this.status,
    required this.date,
    this.invoiceUrl,
    this.bookingId,
  });
}

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});

  final SessionData session;

  String _getSessionDetailsPath() {
    final statusString = session.status == SessionStatus.completed
        ? 'completed'
        : session.status == SessionStatus.cancelled
        ? 'cancelled'
        : 'upcoming';

    final queryParams = {
      'trainerName': session.trainerName,
      'trainerImageUrl': session.trainerImageUrl,
      'sessionType': session.sessionType,
      'duration': session.duration,
      'status': statusString,
      'date': session.date,
    };
    if (session.bookingId != null && session.bookingId!.isNotEmpty) {
      queryParams['bookingId'] = session.bookingId!;
    }
    debugPrint(
      'SessionCard: _getSessionDetailsPath called with queryParams: $queryParams',
    );

    final uri = Uri(
      path: SessionDetailsRoute.path,
      queryParameters: queryParams,
    );
    return uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(_getSessionDetailsPath());
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
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: session.trainerImageUrl.isNotEmpty
                      ? NetworkImage(session.trainerImageUrl)
                      : null,
                  child: session.trainerImageUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 24.sp,
                          color: AppColors.grey400,
                        )
                      : null,
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
                            session.date,
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
            if (session.status == SessionStatus.completed) ...[
              SizedBox(height: AppSpacing.lg),
              SessionActionButtons(session: session),
            ],
          ],
        ),
      ),
    );
  }
}
