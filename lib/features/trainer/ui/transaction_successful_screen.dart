import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_fitness/core/constants/app_assets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/session_popup_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/service/calendar_service.dart';

class TransactionSuccessfulScreen extends StatefulWidget {
  const TransactionSuccessfulScreen({
    super.key,
    required this.amount,
    this.paymentMethod = 'Standard Charted Card',
    this.cardNumber = '1234 5678 2345',
    this.trainerName,
    this.sessionName,
    this.bookingId,
    this.sessionDate,
    this.sessionTime,
    this.sessionStartTime,
    this.currency,
    this.durationMinutes = 60,
  });

  final double amount;
  final String? currency;
  final String paymentMethod;
  final String cardNumber;
  final String? trainerName;
  final String? sessionName;
  final String? bookingId;
  final String? sessionDate;
  final String? sessionTime;
  final DateTime? sessionStartTime;
  final int durationMinutes;

  @override
  State<TransactionSuccessfulScreen> createState() =>
      _TransactionSuccessfulScreenState();
}

class _TransactionSuccessfulScreenState
    extends State<TransactionSuccessfulScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      // if (mounted) {
      _showCalendarPrompt();
      // }
    });
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Start confetti animation
    _confettiController.play();

    // Show calendar prompt after a short delay
  }

  /// Calendar event title: "${sessionName} with ${trainerName}".
  String get _calendarEventTitle {
    print("Session Name ::: ${widget.sessionName?.trim() ?? "NUll"}");
    final name = (widget.sessionName?.trim().isNotEmpty ?? false)
        ? widget.sessionName!.trim()
        : 'Workout Session';
    final trainer = (widget.trainerName?.trim().isNotEmpty ?? false)
        ? widget.trainerName!.trim()
        : 'Trainer';
    return '$name with $trainer';
  }

  Future<void> _showCalendarPrompt() async {
    final calendarService = CalendarService();

    // Check if already added
    if (widget.sessionStartTime != null) {
      final isAlreadyAdded = await calendarService.isEventAlreadyAdded(
        title: _calendarEventTitle,
        start: widget.sessionStartTime!,
        end: widget.sessionStartTime!.add(
          Duration(minutes: widget.durationMinutes),
        ),
      );

      if (isAlreadyAdded) return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 32.h),
              // Icon Container
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.primary,
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Text Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Text(
                      'Save to Calendar?',
                      style: AppTextStyle.text20SemiBold.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Would you like to add this session to your calendar? We\'ll set a reminder so you stay on track with your fitness goals.',
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.grey400,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              // Actions
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Yes, Add it',
                      size: ButtonSize.large,
                      width: double.infinity,
                      backgroundColor: AppColors.primary,
                      onPressed: () async {
                        Navigator.pop(context);
                        await _addEventToCalendar();
                      },
                    ),
                    SizedBox(height: 8.h),
                    CustomButton(
                      text: 'Later',
                      type: ButtonType.text,
                      width: double.infinity,
                      textColor: AppColors.grey400,
                      onPressed: () => Navigator.pop(context),
                      textStyle: AppTextStyle.text14Medium.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addEventToCalendar() async {
    if (widget.sessionStartTime == null) return;

    final calendarService = CalendarService();

    // Show loading indicator
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adding to calendar...'),
        duration: Duration(seconds: 1),
      ),
    );

    final success = await calendarService.createEvent(
      title:
          '${widget.sessionName?.trim() ?? "Workout Session"} with ${widget.trainerName?.trim() ?? 'Trainer'}',
      description:
          'Booking ID: ${widget.bookingId ?? 'N/A'}\nSession with Focus Fitness.',
      start: widget.sessionStartTime!,
      end: widget.sessionStartTime!.add(
        Duration(minutes: widget.durationMinutes),
      ),
      reminderMinutes: [10, 30],
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Successfully added to calendar!'
                : 'Failed to add to calendar',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding.left,
                      vertical: AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        _SuccessIcon(),
                        SizedBox(height: AppSpacing.xl),
                        Text(
                          'Booking Confirmed!',
                          style: AppTextStyle.text24SemiBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Your session has been successfully booked.',
                          style: AppTextStyle.text16Medium.copyWith(
                            color: AppColors.grey400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          CurrencyFormatter.format(
                            widget.amount,
                            widget.currency,
                          ),
                          style: AppTextStyle.text24SemiBold.copyWith(
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.xl + AppSpacing.md),
                        _BookingDetailsSection(
                          trainerName: widget.trainerName,
                          sessionDate: widget.sessionDate,
                          sessionTime: widget.sessionTime,
                        ),
                        SizedBox(height: AppSpacing.xl + 20.h),
                      ],
                    ),
                  ),
                ),
                _GoToHomeButton(
                  bookingId: widget.bookingId,
                  trainerName: widget.trainerName,
                  sessionDate: widget.sessionDate,
                  sessionTime: widget.sessionTime,
                  sessionStartTime: widget.sessionStartTime,
                ),
              ],
            ),
            // Confetti overlay - multiple emitters...
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2, // Blast upwards
                maxBlastForce: 8,
                minBlastForce: 3,
                emissionFrequency: 0.03,
                numberOfParticles: 50,
                gravity: 0.2,
                shouldLoop: false,
              ),
            ),
            // Additional confetti from left
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 3,

                maxBlastForce: 6,
                minBlastForce: 2,
                emissionFrequency: 0.04,
                numberOfParticles: 50,
                gravity: 0.2,
                shouldLoop: false,
              ),
            ),
            // Additional confetti from right
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 2 * pi / 3,
                maxBlastForce: 6,
                minBlastForce: 2,
                emissionFrequency: 0.04,
                numberOfParticles: 50,
                gravity: 0.2,
                shouldLoop: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: AppRadius.medium,
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssets.securePayment,
          width: 50.w,
          height: 50.w,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _BookingDetailsSection extends StatelessWidget {
  const _BookingDetailsSection({
    this.trainerName,
    this.sessionDate,
    this.sessionTime,
  });

  final String? trainerName;
  final String? sessionDate;
  final String? sessionTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        // color: AppColors.whiteBlue,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Trainer',
            value: trainerName ?? 'N/A',
            icon: Icons.person_outline,
          ),
          Divider(color: AppColors.grey200, height: 24.h),
          _DetailRow(
            label: 'Date',
            value: sessionDate ?? 'N/A',
            icon: Icons.calendar_today_outlined,
          ),
          Divider(color: AppColors.grey200, height: 24.h),
          _DetailRow(
            label: 'Time',
            value: sessionTime ?? 'N/A',
            icon: Icons.access_time,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.grey400),
        SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyle.text14SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _GoToHomeButton extends StatelessWidget {
  const _GoToHomeButton({
    this.trainerName,
    this.sessionDate,
    this.sessionTime,
    this.sessionStartTime,
    this.bookingId,
  });
  final String? bookingId;
  final String? trainerName;
  final String? sessionDate;
  final String? sessionTime;
  final DateTime? sessionStartTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding.left,
        right: AppSpacing.screenPadding.right,
        top: AppSpacing.md,
        bottom: AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        text: 'Go to home',
        size: ButtonSize.large,
        width: double.infinity,
        height: 52.h,
        backgroundColor: AppColors.primary,
        textColor: AppColors.background,
        textStyle: AppTextStyle.text16SemiBold.copyWith(
          color: AppColors.background,
        ),
        borderRadius: 12.r,
        isEnabled: true,
        onPressed: () {
          // Navigate to home/dashboard
          context.go('/dashboard/home');
        },
      ),
    );
  }
}
