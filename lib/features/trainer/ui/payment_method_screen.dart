import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/payment_method_provider.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({
    super.key,
    this.amount = 100.00,
    this.trainerId = '',
    this.sessionPlanId = '',
    this.dateId = '',
    this.timeSlot = '',
    this.durationMinutes = 60,
    this.availableDates = const [],
  });

  final double amount;
  final String trainerId;
  final String sessionPlanId;
  final String dateId;
  final String timeSlot;
  final int durationMinutes;
  final List<Map<String, dynamic>> availableDates;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentMethodProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Payment Method',
               
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding.left,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PaymentOption(
                        title: 'Paypal',
                        subtitle: 'email@website.com',
                        paymentType: PaymentType.paypal,
                        trainerId: trainerId,
                        sessionPlanId: sessionPlanId,
                        dateId: dateId,
                        timeSlot: timeSlot,
                        durationMinutes: durationMinutes,
                        availableDates: availableDates,
                        amount: amount,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _PaymentOption(
                        title: 'Apple Pay',
                        subtitle: 'email@website.com',
                        paymentType: PaymentType.applePay,
                        trainerId: trainerId,
                        sessionPlanId: sessionPlanId,
                        dateId: dateId,
                        timeSlot: timeSlot,
                        durationMinutes: durationMinutes,
                        availableDates: availableDates,
                        amount: amount,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _PaymentOption(
                        title: 'Credit Card',
                        subtitle: '1234 **** **** 1234',
                        paymentType: PaymentType.creditCard,
                        trainerId: trainerId,
                        sessionPlanId: sessionPlanId,
                        dateId: dateId,
                        timeSlot: timeSlot,
                        durationMinutes: durationMinutes,
                        availableDates: availableDates,
                        amount: amount,
                      ),
                    ],
                  ),
                ),
              ),
              _PayButton(
                amount: amount,
                trainerId: trainerId,
                sessionPlanId: sessionPlanId,
                dateId: dateId,
                timeSlot: timeSlot,
                durationMinutes: durationMinutes,
                availableDates: availableDates,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.paymentType,
    required this.trainerId,
    required this.sessionPlanId,
    required this.dateId,
    required this.timeSlot,
    required this.durationMinutes,
    required this.availableDates,
    required this.amount,
  });

  final String title;
  final String subtitle;
  final PaymentType paymentType;
  final String trainerId;
  final String sessionPlanId;
  final String dateId;
  final String timeSlot;
  final int durationMinutes;
  final List<Map<String, dynamic>> availableDates;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodProvider>();
    final isSelected = provider.selectedPaymentType == paymentType;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        provider.selectPaymentType(paymentType);
        
        // Call booking API when payment method is selected
        if (trainerId.isNotEmpty && sessionPlanId.isNotEmpty && dateId.isNotEmpty && timeSlot.isNotEmpty) {
          final success = await provider.bookSession(
            trainerId: trainerId,
            sessionPlanId: sessionPlanId,
            dateId: dateId,
            timeSlot: timeSlot,
            durationMinutes: durationMinutes,
            availableDatesData: availableDates,
          );
          
          if (success && context.mounted) {
            // Navigate to transaction successful screen
            final paymentMethod = _getPaymentMethodName(paymentType);
            final cardNumber = _getCardNumber(paymentType);
            context.push(
              '/transaction-successful?amount=${amount.toStringAsFixed(2)}&paymentMethod=${Uri.encodeComponent(paymentMethod)}&cardNumber=${Uri.encodeComponent(cardNumber)}',
            );
          } else if (context.mounted && provider.bookingError != null) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  provider.bookingError ?? 'Failed to book session',
                  style: AppTextStyle.text16Regular.copyWith(
                    color: AppColors.background,
                  ),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: 20.w,
            //   height: 20.w,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: isSelected ? AppColors.primary : Colors.transparent,
            //     border: Border.all(
            //       color: isSelected
            //           ? AppColors.primary.withOpacity(0.3)
            //           : AppColors.grey300,
            //       width: isSelected ? 3 : 1.5,
            //     ),
            //   ),
            //   child: isSelected
            //       ? Center(
            //           child: Container(
            //             width: 10.w,
            //             height: 10.w,
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: AppColors.primary,
            //             ),
            //           ),
            //         )
            //       : null,
            // ),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: isSelected ? Icon(Icons.radio_button_checked_rounded, color: AppColors.primary, size: 20.sp) : Icon(Icons.circle_outlined, color: AppColors.grey300, size: 20.sp),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.text16SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
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
    );
  }

  String _getPaymentMethodName(PaymentType type) {
    switch (type) {
      case PaymentType.paypal:
        return 'Paypal';
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.creditCard:
        return 'Standard Charted Card';
    }
  }

  String _getCardNumber(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return '1234 5678 2345';
      case PaymentType.paypal:
      case PaymentType.applePay:
        return 'email@website.com';
    }
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton({
    required this.amount,
    required this.trainerId,
    required this.sessionPlanId,
    required this.dateId,
    required this.timeSlot,
    required this.durationMinutes,
    required this.availableDates,
  });

  final double amount;
  final String trainerId;
  final String sessionPlanId;
  final String dateId;
  final String timeSlot;
  final int durationMinutes;
  final List<Map<String, dynamic>> availableDates;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodProvider>();
    final selectedPaymentType = provider.selectedPaymentType;

    String getPaymentMethodName(PaymentType? type) {
      switch (type) {
        case PaymentType.paypal:
          return 'Paypal';
        case PaymentType.applePay:
          return 'Apple Pay';
        case PaymentType.creditCard:
          return 'Standard Charted Card';
        case null:
          return 'Standard Charted Card';
      }
    }

    String getCardNumber(PaymentType? type) {
      switch (type) {
        case PaymentType.creditCard:
          return '1234 5678 2345';
        case PaymentType.paypal:
        case PaymentType.applePay:
        case null:
          return 'email@website.com';
      }
    }

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
        text: provider.isBooking
            ? 'Booking...'
            : 'Pay \$${amount.toStringAsFixed(2)}',
        size: ButtonSize.large,
        width: double.infinity,
        height: 52.h,
        backgroundColor: AppColors.primary,
        textColor: AppColors.background,
        textStyle: AppTextStyle.text16SemiBold.copyWith(
          color: AppColors.background,
        ),
        borderRadius: 12.r,
        isEnabled: !provider.isBooking,
        onPressed: provider.isBooking
            ? null
            : () async {
                // Call booking API when Pay button is clicked
                if (trainerId.isNotEmpty && sessionPlanId.isNotEmpty && dateId.isNotEmpty && timeSlot.isNotEmpty) {
                  final success = await provider.bookSession(
                    trainerId: trainerId,
                    sessionPlanId: sessionPlanId,
                    dateId: dateId,
                    timeSlot: timeSlot,
                    durationMinutes: durationMinutes,
                    availableDatesData: availableDates,
                  );
                  
                  if (success && context.mounted) {
                    // Navigate to transaction successful screen
                    final paymentMethod = getPaymentMethodName(selectedPaymentType);
                    final cardNumber = getCardNumber(selectedPaymentType);
                    context.push(
                      '/transaction-successful?amount=${amount.toStringAsFixed(2)}&paymentMethod=${Uri.encodeComponent(paymentMethod)}&cardNumber=${Uri.encodeComponent(cardNumber)}',
                    );
                  } else if (context.mounted && provider.bookingError != null) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.bookingError ?? 'Failed to book session',
                          style: AppTextStyle.text16Regular.copyWith(
                            color: AppColors.background,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
      ),
    );
  }
}

