import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:focus_fitness/core/theme/app_colors.dart';
import 'package:focus_fitness/core/theme/app_text_styles.dart';
import 'package:focus_fitness/core/theme/app_radius.dart';
import 'package:focus_fitness/features/session/data/models/booking_model.dart';
import 'package:focus_fitness/features/session/provider/session_history_provider.dart';
import 'session_completion_bottom_sheet.dart';

class PendingCompletionNudge extends StatelessWidget {
  const PendingCompletionNudge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionHistoryProvider>(
      builder: (context, provider, child) {
        if (provider.pendingCompletionBookings.isEmpty) {
          return const SizedBox.shrink();
        }

        final booking = provider.pendingCompletionBookings.first;
        final trainerName = booking.trainer?.fullName ?? 'Trainer';

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 10),
                child: child,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 24.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.whiteBlue,
              borderRadius: AppRadius.medium,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _showSessionCompletionBottomSheet(context, booking),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Action',
                          style: AppTextStyle.text12Medium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Did you finish your session with $trainerName?',
                          style: AppTextStyle.text14Medium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.grey400,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSessionCompletionBottomSheet(
    BuildContext context,
    BookingModel booking,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => SessionCompletionBottomSheet(booking: booking),
    );
  }
}
