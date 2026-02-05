import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OtpResendTimer extends StatefulWidget {
  final DateTime expiresAt;
  final VoidCallback onResend;

  const OtpResendTimer({
    super.key,
    required this.expiresAt,
    required this.onResend,
  });

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer> {
  Timer? _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant OtpResendTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expiresAt != oldWidget.expiresAt) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _updateTimeLeft();
    if (_timeLeft.inSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _updateTimeLeft();
        if (_timeLeft.inSeconds <= 0) {
          timer.cancel();
        }
      });
    }
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.expiresAt.difference(now);
    setState(() {
      _timeLeft = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _timeLeft.inMinutes;
    final seconds = _timeLeft.inSeconds % 60;
    final timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';

    final isExpired = _timeLeft.inSeconds <= 0;

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isExpired) ...[
            Text(
              'Expires in: $timeString',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
          ],
          GestureDetector(
            onTap: isExpired ? widget.onResend : null,
            child: Text(
              'Resend Code',
              style: AppTextStyle.text16Regular.copyWith(
                color: isExpired ? AppColors.primary : AppColors.grey300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
