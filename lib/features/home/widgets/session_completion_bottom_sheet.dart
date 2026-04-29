import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:focus_fitness/core/theme/app_colors.dart';
import 'package:focus_fitness/core/theme/app_text_styles.dart';
import 'package:focus_fitness/core/utils/time_utils.dart';
import 'package:focus_fitness/core/widgets/show_image.dart';
import 'package:focus_fitness/core/widgets/buttons/custom_bottom.dart';
import 'package:focus_fitness/features/session/data/models/booking_model.dart';
import 'package:focus_fitness/features/session/provider/session_history_provider.dart';

import 'package:focus_fitness/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_fitness/features/session/widgets/session_card.dart'
    show SessionData, SessionStatus;

class SessionCompletionBottomSheet extends StatefulWidget {
  final BookingModel booking;
  const SessionCompletionBottomSheet({super.key, required this.booking});

  @override
  State<SessionCompletionBottomSheet> createState() =>
      _SessionCompletionBottomSheetState();
}

class _SessionCompletionBottomSheetState
    extends State<SessionCompletionBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final trainerName = booking.trainer?.fullName ?? 'Trainer';
    final trainerImage = booking.trainer?.profilePhoto ?? '';
    final date = TimeUtils.formatToLocal(
      booking.startTime,
      format: 'MMM dd, yyyy',
    );
    final time = TimeUtils.formatToLocal(booking.startTime, format: 'h:mm a');

    return SlideTransition(
      position: _offsetAnimation,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 40.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Session Confirmation',
                      style: AppTextStyle.text24SemiBold.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Did you finish your session?',
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: ShowImage(
                              imageUrl: trainerImage,
                              width: 56.r,
                              height: 56.r,
                              isCircle: true,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trainerName,
                                  style: AppTextStyle.text18SemiBold.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      date,
                                      style: AppTextStyle.text14Medium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Icon(
                                      Icons.access_time,
                                      size: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      time,
                                      style: AppTextStyle.text14Medium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    CustomButton(
                      text: 'Yes, Completed',
                      onPressed: () async {
                        final provider = Provider.of<SessionHistoryProvider>(
                          context,
                          listen: false,
                        );
                        final success = await provider.completeBooking(
                          booking.id,
                        );
                        if (mounted) {
                          Navigator.pop(context);
                          if (success) {
                            final sessionData = SessionData(
                              trainerName: trainerName,
                              trainerImageUrl: trainerImage,
                              sessionType:
                                  booking.sessionPlan?.title ??
                                  'Personal Training',
                              duration:
                                  '${booking.sessionPlan?.durationMinutes ?? 60} mins',
                              status: SessionStatus.completed,
                              date: date,
                              startTime: time,
                              bookingId: booking.id,
                              booking: booking,
                            );

                            context.push(
                              SessionDetailsRoute.path,
                              extra: sessionData,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Session marked as completed!'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          }
                        }
                      },
                      type: ButtonType.gradient,
                      width: double.infinity,
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Ask me later',
                        style: AppTextStyle.text16Medium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              right: 20.w,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: AppTextStyle.text14Medium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
