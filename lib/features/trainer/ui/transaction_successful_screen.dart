import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_assets.dart';
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
  });

  final double amount;
  final String paymentMethod;
  final String cardNumber;

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
                          'Transaction Successful',
                          style: AppTextStyle.text24SemiBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Your top up has been successful done',
                          style: AppTextStyle.text16Medium.copyWith(
                            color: AppColors.grey400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.xl + AppSpacing.md),
                        _SessionBookedSection(amount: widget.amount),
                        SizedBox(height: AppSpacing.lg),
                        _TransactionMethodSection(
                          paymentMethod: widget.paymentMethod,
                          cardNumber: widget.cardNumber,
                        ),
                        SizedBox(height: AppSpacing.xl + 20.h),
                      ],
                    ),
                  ),
                ),
                _GoToHomeButton(),
              ],
            ),
            // Confetti overlay - multiple emitters for scattered effect
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
                // maximumSize: Size(10.w, 10.h),
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
              //  maximumSize: Size(10.w, 10.h),
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
                // maximumSize: Size(10.w, 10.h),
                // colors: const [
                  
                // ],
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

class _SessionBookedSection extends StatelessWidget {
  const _SessionBookedSection({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Session Booked',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.grey400,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: AppTextStyle.text24Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        CustomPaint(
          size: Size(double.infinity, 1.h),
          painter: _DashedLinePainter(),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey300
      ..strokeWidth = 1.h;

    const dashWidth = 10.0;
    const dashSpace = 10.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransactionMethodSection extends StatelessWidget {
  const _TransactionMethodSection({
    required this.paymentMethod,
    required this.cardNumber,
  });

  final String paymentMethod;
  final String cardNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Method',
          style: AppTextStyle.text16Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.whiteBlue,
            borderRadius: AppRadius.medium,
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: AppRadius.small,
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 24.sp,
                  color: AppColors.whiteBlue,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod,
                      style: AppTextStyle.text16SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      cardNumber,
                      style: AppTextStyle.text12SemiBold.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoToHomeButton extends StatelessWidget {
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
          
          // Schedule session popup to show after 2 seconds
          final sessionPopupProvider = Provider.of<SessionPopupProvider>(
            context,
            listen: false,
          );
          
          sessionPopupProvider.schedulePopup(
            SessionPopupData(
              trainerName: 'James Gustavsson',
              trainerImageUrl: null, // You can add actual image URL here
              sessionDate: 'Monday Jun 9, 2025',
              sessionTime: '7:00 - 7:30 am',
              onJoinSession: () {
                // TODO: Handle join session action
                // You can navigate to session screen or start video call
              },
            ),
            delay: const Duration(seconds: 5),
          );
        },
      ),
    );
  }
}

