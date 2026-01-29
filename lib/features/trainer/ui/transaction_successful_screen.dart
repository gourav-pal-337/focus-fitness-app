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
import '../../../core/widgets/buttons/custom_bottom.dart';

class TransactionSuccessfulScreen extends StatefulWidget {
  const TransactionSuccessfulScreen({
    super.key,
    required this.amount,
    this.paymentMethod = 'Standard Charted Card',
    this.cardNumber = '1234 5678 2345',
    this.trainerName,
    this.bookingId,
    this.sessionDate,
    this.sessionTime,
    this.sessionStartTime,
  });

  final double amount;
  final String paymentMethod;
  final String cardNumber;
  final String? trainerName;
  final String? bookingId;
  final String? sessionDate;
  final String? sessionTime;
  final DateTime? sessionStartTime;

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
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Start confetti animation
    _confettiController.play();
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
