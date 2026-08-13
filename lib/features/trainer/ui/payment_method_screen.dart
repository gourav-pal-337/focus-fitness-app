import 'dart:developer';
import 'package:focus_fitness/core/widgets/app_modal_sheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/utils/currency_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/trainer_profile_provider.dart';
import '../provider/payment_method_provider.dart';
import '../provider/system_settings_provider.dart';
import '../widgets/payment_verification_sheet.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'paypal_webview_screen.dart';
import '../../subscriptions/data/repository/subscription_repository.dart';
import '../../authentication/data/repository/auth_repository.dart'
    show ResultExtension;

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({
    super.key,
    this.amount = 100.00,
    this.baseAmount = 100.00,
    this.trainerId = '',
    this.sessionPlanId = '',
    this.dateId = '',
    this.timeSlot = '',
    this.durationMinutes = 60,
    this.availableDates = const [],
    this.isSubscription = false,
    this.planType = '',
    this.trainerName = '',
    this.sessionName = '',
    this.sessionDate = '',
    this.sessionTime = '',
    this.sessionStartTime = '',
    this.mode,
    this.currency,
    this.trainerTimeZone,
  });

  final double amount;
  final double baseAmount;
  final String trainerId;
  final String sessionPlanId;
  final String dateId;
  final String timeSlot;
  final int durationMinutes;
  final List<Map<String, dynamic>> availableDates;
  final bool isSubscription;
  final String planType;

  // Additional booking details
  final String trainerName;
  final String sessionName;
  final String sessionDate;
  final String sessionTime;
  final String sessionStartTime;
  final String? mode;
  final String? currency;
  final String? trainerTimeZone;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  void initState() {
    super.initState();
    _setInitialPaymentMethod();
  }

  void _setInitialPaymentMethod() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final trainerProvider = context.read<TrainerProfileProvider>();
      final paymentProvider = context.read<PaymentMethodProvider>();
      final trainer = trainerProvider.trainer;

      if (trainer != null) {
        if (trainer.isStripeConnected) {
          paymentProvider.selectPaymentType(PaymentType.creditCard);
        } else if (trainer.isPayPalConnected) {
          paymentProvider.selectPaymentType(PaymentType.paypal);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainerProvider = context.watch<TrainerProfileProvider>();
    final trainer = trainerProvider.trainer;
    final isStripeConnected = trainer?.isStripeConnected ?? false;
    final isPayPalConnected = trainer?.isPayPalConnected ?? false;
    print("Session Name 2::::::: ${widget.sessionName}");
    log("isStripeConnected: $isStripeConnected");
    log("isPayPalConnected: $isPayPalConnected");
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Payment Method'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.left,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isPayPalConnected && !isStripeConnected)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                color: AppColors.grey400,
                                size: 64.sp,
                              ),

                              SizedBox(height: 16.h),
                              Text(
                                "No connected payment account\nfound for this trainer.",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.text16Medium.copyWith(
                                  color: AppColors.grey400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (isPayPalConnected)
                      _PaymentOption(
                        title: 'Paypal',
                        subtitle: 'Pay securely with your PayPal account',
                        paymentType: PaymentType.paypal,
                        trainerId: widget.trainerId,
                        sessionPlanId: widget.sessionPlanId,
                        dateId: widget.dateId,
                        timeSlot: widget.timeSlot,
                        durationMinutes: widget.durationMinutes,
                        availableDates: widget.availableDates,
                        amount: widget.amount,
                        isSubscription: widget.isSubscription,
                        planType: widget.planType,
                      ),
                    if (isStripeConnected)
                      _PaymentOption(
                        title: 'Stripe',
                        subtitle: 'Credit Card / Digital Wallet',
                        paymentType: PaymentType.creditCard,
                        trainerId: widget.trainerId,
                        sessionPlanId: widget.sessionPlanId,
                        dateId: widget.dateId,
                        timeSlot: widget.timeSlot,
                        durationMinutes: widget.durationMinutes,
                        availableDates: widget.availableDates,
                        amount: widget.amount,
                        isSubscription: widget.isSubscription,
                        planType: widget.planType,
                      ),
                  ],
                ),
              ),
            ),
            if (isPayPalConnected || isStripeConnected)
              _PayButton(
                amount: widget.amount,
                baseAmount: widget.baseAmount,
                trainerId: widget.trainerId,
                sessionPlanId: widget.sessionPlanId,
                dateId: widget.dateId,
                timeSlot: widget.timeSlot,
                durationMinutes: widget.durationMinutes,
                availableDates: widget.availableDates,
                isSubscription: widget.isSubscription,
                planType: widget.planType,
                trainerName: widget.trainerName,
                sessionName: widget.sessionName,
                sessionDate: widget.sessionDate,
                sessionTime: widget.sessionTime,
                sessionStartTime: widget.sessionStartTime,
                mode: widget.mode,
                currency: widget.currency,
                trainerTimeZone: widget.trainerTimeZone,
              ),
          ],
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
    required this.isSubscription,
    required this.planType,
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
  final bool isSubscription;
  final String planType;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodProvider>();
    final isSelected = provider.selectedPaymentType == paymentType;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        provider.selectPaymentType(paymentType);
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
              child: isSelected
                  ? Icon(
                      Icons.radio_button_checked_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: AppColors.grey300,
                      size: 20.sp,
                    ),
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
}

class _PayButton extends StatelessWidget {
  const _PayButton({
    required this.amount,
    required this.baseAmount,
    required this.trainerId,
    required this.sessionPlanId,
    required this.dateId,
    required this.timeSlot,
    required this.durationMinutes,
    required this.availableDates,
    required this.isSubscription,
    required this.planType,
    required this.trainerName,
    required this.sessionName,
    required this.sessionDate,
    required this.sessionTime,
    required this.sessionStartTime,
    this.mode,
    this.currency,
    this.trainerTimeZone,
  });

  final double amount;
  final double baseAmount;
  final String trainerId;
  final String sessionPlanId;
  final String dateId;
  final String timeSlot;
  final int durationMinutes;
  final List<Map<String, dynamic>> availableDates;
  final bool isSubscription;
  final String planType;
  final String trainerName;
  final String sessionName;
  final String sessionDate;
  final String sessionTime;
  final String sessionStartTime;
  final String? mode;
  final String? currency;
  final String? trainerTimeZone;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodProvider>();
    final settingsProvider = context.watch<SystemSettingsProvider>();
    final trainerProvider = context.watch<TrainerProfileProvider>();

    final selectedPaymentType = provider.selectedPaymentType;
    final settings = settingsProvider.feeSettings;
    final trainer = trainerProvider.trainer;
    final vatConfig = trainer?.vatConfig;

    // Recalculate components to ensure accuracy and get the latest
    double serviceFee = 0;
    double vatAmount = 0;
    double totalChargedAmount = amount;

    double vatPercent = settings?.vatTaxPercent ?? 0;
    if (vatConfig != null) {
      vatPercent = vatConfig.mode == 'percentage' ? vatConfig.percent : 0.0;
    }

    if (settings != null) {
      serviceFee = settings.platformFeeType == 'fixed'
          ? settings.platformFee
          : (baseAmount * (settings.platformFee / 100));

      vatAmount = baseAmount * (vatPercent / 100);
      totalChargedAmount = baseAmount + serviceFee + vatAmount;
    }

    String getPaymentMethodName(PaymentType? type) {
      switch (type) {
        case PaymentType.paypal:
          return 'Paypal';
        case PaymentType.applePay:
          return 'Apple Pay';
        case PaymentType.creditCard:
          return 'Stripe';
        case null:
          return 'Stripe';
      }
    }

    String getCardNumber(PaymentType? type) {
      switch (type) {
        case PaymentType.creditCard:
          return 'Credit Card / Digital Wallet';
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
            : 'Pay ${CurrencyFormatter.format(totalChargedAmount, settings?.platformFeeCurrency ?? currency)}',
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
            ? () {
                print("tap tap...");
              }
            : () async {
                print("tap tap tap...");
                print("mode: $mode");
                // return;
                if (isSubscription) {
                  if (trainerId.isEmpty || planType.isEmpty) return;

                  final subscriptionRepo = SubscriptionRepository();
                  final providerString =
                      selectedPaymentType == PaymentType.creditCard
                      ? 'stripe'
                      : 'paypal';
                  final result = await subscriptionRepo.checkoutSubscription(
                    trainerId,
                    planType,
                    provider: providerString,
                  );

                  if (!context.mounted) return;

                  result.when(
                    success: (response) async {
                      if (selectedPaymentType == PaymentType.creditCard) {
                        Stripe.publishableKey = response.publishableKey ?? "";
                        await Stripe.instance.applySettings();
                        // This means Stripe
                        if (response.clientSecret != null &&
                            response.clientSecret!.isNotEmpty) {
                          try {
                            log(
                              "paymentSheerParameters : ${response.clientSecret}. customerId :: ${response.customerId}. ephemeralKey : ${response.ephemeralKey}",
                            );
                            await Stripe.instance.initPaymentSheet(
                              paymentSheetParameters:
                                  SetupPaymentSheetParameters(
                                    paymentIntentClientSecret:
                                        response.clientSecret,
                                    customerId: response.customerId,
                                    customerEphemeralKeySecret:
                                        response.ephemeralKey,
                                    merchantDisplayName: 'Focus Fitness',
                                  ),
                            );
                            await Stripe.instance.presentPaymentSheet();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Subscription Successful!'),
                              ),
                            );
                          } on StripeException catch (e) {
                            log("error while makeing payment 2: $e");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Payment Canceled/Failed: ${e.error.localizedMessage}',
                                ),
                              ),
                            );
                          } catch (e) {
                            log("error while makeing payment : $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('An error occurred: $e')),
                            );
                          }
                        } else if (response.checkoutUrl != null &&
                            response.checkoutUrl!.isNotEmpty) {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaypalWebViewScreen(
                                checkoutUrl: response.checkoutUrl!,
                              ),
                            ),
                          );

                          if (result == true && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Subscription Successful!'),
                              ),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment Canceled/Failed'),
                              ),
                            );
                          }
                        }
                      } else {
                        // Paypal
                        if (response.checkoutUrl != null &&
                            response.checkoutUrl!.isNotEmpty) {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaypalWebViewScreen(
                                checkoutUrl: response.checkoutUrl!,
                              ),
                            ),
                          );

                          if (result == true && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Subscription Successful!'),
                              ),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment Canceled/Failed'),
                              ),
                            );
                          }
                        }
                      }
                    },
                    failure: (message, code) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    },
                  );
                  return;
                }
                print(
                  "trainer id : ${trainerId.isNotEmpty}  sessopnplan : ${sessionPlanId} dateId : ${dateId.isNotEmpty} timeslot : ${timeSlot.isNotEmpty}",
                );
                // Call booking API when Pay button is clicked
                if (trainerId.isNotEmpty &&
                    sessionPlanId.isNotEmpty &&
                    dateId.isNotEmpty &&
                    timeSlot.isNotEmpty) {
                  final providerString =
                      selectedPaymentType == PaymentType.creditCard
                      ? 'stripe'
                      : 'paypal';

                  final initiateResponse = await provider.initiatePayment(
                    trainerId: trainerId,
                    sessionPlanId: sessionPlanId,
                    dateId: dateId,
                    timeSlot: timeSlot,
                    durationMinutes: durationMinutes,
                    availableDatesData: availableDates,
                    provider: providerString,
                    serviceFee: serviceFee,
                    vatAmount: vatAmount,
                    totalAmount: totalChargedAmount,
                    platformFeeValue: settings?.platformFee,
                    platformFeeType: settings?.platformFeeType,
                    vatTaxPercent: vatPercent,
                    mode: mode,
                    trainerTimeZone: trainerTimeZone,
                  );

                  log("initiateResponse : ${initiateResponse?.payment} ");

                  if (initiateResponse != null && initiateResponse.success) {
                    bool paymentCompleted = false;
                    final bookingId =
                        initiateResponse.payment?['bookingId'] as String?;

                    print('bookingId :::: ${initiateResponse.payment}');
                    if (selectedPaymentType == PaymentType.creditCard) {
                      Stripe.publishableKey =
                          initiateResponse.publishableKey ?? "";
                      await Stripe.instance.applySettings();
                      if (initiateResponse.clientSecret != null &&
                          initiateResponse.clientSecret!.isNotEmpty) {
                        debugPrint('bookingId : $bookingId');
                        try {
                          if (bookingId != null) {
                            await provider.updatePaymentStatus(
                              bookingId: bookingId,
                              status: 'processing',
                            );
                          }
                          await Stripe.instance.initPaymentSheet(
                            paymentSheetParameters: SetupPaymentSheetParameters(
                              paymentIntentClientSecret:
                                  initiateResponse.clientSecret,
                              customerId: initiateResponse.customerId,
                              customerEphemeralKeySecret:
                                  initiateResponse.ephemeralKey,
                              merchantDisplayName: 'Focus Fitness',
                            ),
                          );
                          await Stripe.instance.presentPaymentSheet();
                          paymentCompleted = true;
                        } on StripeException catch (e) {
                          if (bookingId != null) {
                            await provider.updatePaymentStatus(
                              bookingId: bookingId,
                              status: 'failed',
                            );
                          }
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Payment Canceled/Failed: ${e.error.localizedMessage}',
                              ),
                            ),
                          );
                          return;
                        } catch (e) {
                          if (bookingId != null) {
                            await provider.updatePaymentStatus(
                              bookingId: bookingId,
                              status: 'failed',
                            );
                          }
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                          return;
                        }
                      }
                    } else {
                      // Paypal
                      if (initiateResponse.checkoutUrl != null &&
                          initiateResponse.checkoutUrl!.isNotEmpty) {
                        if (bookingId != null) {
                          await provider.updatePaymentStatus(
                            bookingId: bookingId,
                            status: 'processing',
                          );
                        }
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaypalWebViewScreen(
                              checkoutUrl: initiateResponse.checkoutUrl!,
                            ),
                          ),
                        );

                        if (result == true) {
                          paymentCompleted = true;
                        } else {
                          if (bookingId != null) {
                            await provider.updatePaymentStatus(
                              bookingId: bookingId,
                              status: 'failed',
                            );
                          }
                        }
                      }
                    }

                    if (paymentCompleted && context.mounted) {
                      final intentId = selectedPaymentType == PaymentType.paypal
                          ? (initiateResponse.orderId ?? '')
                          : (initiateResponse.paymentIntentId ?? '');

                      final paymentMethod = getPaymentMethodName(
                        selectedPaymentType,
                      );
                      final cardNumber = getCardNumber(selectedPaymentType);

                      _showVerifyingSheet(
                        context,
                        intentId: intentId,
                        isPaypal: selectedPaymentType == PaymentType.paypal,
                        onSuccess: (bookingData) {
                          if (!context.mounted) return;
                          context.push(
                            '/transaction-successful?amount=${totalChargedAmount.toStringAsFixed(2)}&currency=${settings?.platformFeeCurrency ?? currency}&paymentMethod=${Uri.encodeComponent(paymentMethod)}&cardNumber=${Uri.encodeComponent(cardNumber)}&trainerName=${Uri.encodeComponent(trainerName)}&sessionName=${Uri.encodeComponent(sessionName)}&sessionDate=${Uri.encodeComponent(sessionDate)}&sessionTime=${Uri.encodeComponent(sessionTime)}&sessionStartTime=${Uri.encodeComponent(sessionStartTime)}&durationMinutes=$durationMinutes&bookingId=${bookingData['_id'] ?? trainerId}',
                          );
                        },
                        onError: (error) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                error,
                                style: AppTextStyle.text16Regular.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    }
                  } else if (context.mounted && provider.bookingError != null) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.bookingError ?? 'Failed to initiate payment',
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

  void _showVerifyingSheet(
    BuildContext context, {
    required String intentId,
    bool isPaypal = false,
    required Function(Map<String, dynamic> bookingData) onSuccess,
    required Function(String error) onError,
  }) {
    showAppModalSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PaymentVerificationSheet(
          intentId: intentId,
          isPaypal: isPaypal,
          onSuccess: (data) {
            Navigator.pop(context);
            onSuccess(data);
          },
          onError: (error) {
            Navigator.pop(context);
            onError(error);
          },
        );
      },
    );
  }
}
