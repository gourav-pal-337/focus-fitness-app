import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/payment_method_provider.dart';

class PaymentVerificationSheet extends StatefulWidget {
  final String intentId;
  final bool isPaypal;
  final Function(Map<String, dynamic> bookingData) onSuccess;
  final Function(String error) onError;

  const PaymentVerificationSheet({
    super.key,
    required this.intentId,
    this.isPaypal = false,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<PaymentVerificationSheet> createState() =>
      _PaymentVerificationSheetState();
}

class _PaymentVerificationSheetState extends State<PaymentVerificationSheet> {
  @override
  void initState() {
    super.initState();
    // We use addPostFrameCallback to ensure the provider is accessible if needed,
    // though context.read is fine in initState for one-off calls.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyPayment();
    });
  }

  Future<void> _verifyPayment() async {
    // await Future.delayed(const Duration(seconds: 3));
    int attempts = 0;
    const int maxRetries = 3;
    const Duration delay = Duration(seconds: 3);

    while (attempts < maxRetries) {
      attempts++;
      log('PaymentVerification: Attempt $attempts of $maxRetries');

      await Future.delayed(delay);
      if (!mounted) return;

      final provider = context.read<PaymentMethodProvider>();
      final result = await provider.verifyPaymentStatus(
        widget.intentId,
        isPaypal: widget.isPaypal,
      );

      if (!mounted) return;

      if (result != null && result['success'] == true) {
        final bookingData = result['booking'] as Map<String, dynamic>?;
        if (bookingData != null) {
          final paymentStatus = bookingData['paymentStatus'] as String?;
          if (paymentStatus == "paid") {
            log('PaymentVerification: Payment confirmed as paid.');
            widget.onSuccess(bookingData);
            return;
          } else {
            log('PaymentVerification: Status is $paymentStatus, retrying...');
          }
        }
      } else {
        log(
          'PaymentVerification: API call failed or returned success=false, retrying...',
        );
      }

      // If this was the last attempt and we still aren't "paid"
      
      if (attempts >= maxRetries) {
        if (result != null && result['success'] == true) {
          final bookingData = result['booking'] as Map<String, dynamic>?;
          final paymentStatus =
              bookingData?['paymentStatus'] as String? ?? 'unpaid';
          widget.onError(
            'Payment status: $paymentStatus. Please contact support if you were charged.',
          );
        } else {
          widget.onError(
            provider.bookingError ??
                'Failed to verify payment after $maxRetries attempts',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.md),
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: AppSpacing.xl),
          Text(
            'Verifying Payment',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Please wait while we confirm your booking...',
            textAlign: TextAlign.center,
            style: AppTextStyle.text16Regular.copyWith(
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
