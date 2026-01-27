import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/features/home/widgets/trainer_summary_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/date_time_bar.dart';
import '../provider/trainer_profile_provider.dart';
import '../utils/date_time_utils.dart';
import '../widgets/trainer_profile_header.dart';
import '../widgets/trainer_info_section.dart';
import '../widgets/trainer_stats_row.dart';
import '../widgets/know_more_section.dart';
import '../widgets/date_selector.dart';
import '../widgets/time_slot_selector.dart';

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({
    super.key,
    required this.trainerId,
    this.trainerName = 'James Gustavsson',
    this.trainerSpecialty = 'HIIT & Cardio',
    this.trainerRating = 4.6,
    this.trainerImageUrl,
  });

  final String trainerId;
  final String trainerName;
  final String trainerSpecialty;
  final double trainerRating;
  final String? trainerImageUrl;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrainerProfileProvider()..fetchTrainerProfile(trainerId),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          // print('didPop: $didPop, result: $result');
          // final trainerProv = Provider.of<TrainerProfileProvider>(
          //   context,
          //   listen: false,
          // );
          // if (trainerProv.showBookingConfirmation) {
          //   trainerProv.hideBookingView();
          //   return;
          // }
          // context.pop(result);
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  TrainerProfileHeader(trainerImageUrl: trainerImageUrl),
                  SizedBox(height: 50.h),
                  Consumer<TrainerProfileProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.error != null) {
                        return Center(
                          child: Text(
                            provider.error!,
                            style: AppTextStyle.text14Regular.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                        );
                      }

                      final trainer = provider.trainer;
                      if (trainer == null) {
                        return TrainerInfoSection(
                          name: trainerName,
                          specialty: trainerSpecialty,
                          rating: trainerRating,
                          imageUrl: trainerImageUrl,
                        );
                      }

                      return TrainerInfoSection(
                        name: trainer.fullName ?? trainerName,
                        specialty: trainerSpecialty,
                        rating: trainer.avgRating ?? trainerRating,
                        imageUrl: trainer.profilePhoto ?? trainerImageUrl,
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Consumer<TrainerProfileProvider>(
                    builder: (context, provider, _) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                child: child,
                              );
                            },
                        child: provider.showBookingConfirmation
                            ? _BookingContent(key: const ValueKey('booking'))
                            : _ProfileContent(key: const ValueKey('profile')),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.xl),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: _BookSessionButton(),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TrainerStatsRow(),
        SizedBox(height: AppSpacing.xl),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
          ).copyWith(right: 10),
          child: const TrainerSummarySection(),
          // const KnowMoreSection(),
        ),
        SizedBox(height: AppSpacing.xl),
        const DateSelector(),
        SizedBox(height: AppSpacing.xl),
        const TimeSlotSelector(),
      ],
    );
  }
}

class _BookingContent extends StatelessWidget {
  const _BookingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SessionDateTimeDisplay(),
        SizedBox(height: AppSpacing.xl),
        _SessionTypeSelector(),
        SizedBox(height: AppSpacing.xl),
        _PaymentInfoSection(),
      ],
    );
  }
}

class _SessionDateTimeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final selectedDate = provider.selectedDate;
    final selectedTimeSlot = provider.selectedTimeSlot;

    final formattedDate = selectedDate != null
        ? _formatDate(context, selectedDate)
        : null;

    return DateTimeBar(date: formattedDate, time: selectedTimeSlot);
  }

  String _formatDate(BuildContext context, String dateId) {
    final provider = context.read<TrainerProfileProvider>();
    return DateTimeUtils.formatDateId(dateId, provider.availableDates);
  }
}

class _SessionTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final sessionType = provider.sessionType;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Session Type',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey75,
              borderRadius: AppRadius.medium,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SessionTypeButton(
                    label: 'Online',
                    isSelected: sessionType == SessionType.online,
                    onTap: () {
                      context.read<TrainerProfileProvider>().setSessionType(
                        SessionType.online,
                      );
                    },
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r),
                    ),
                  ),
                ),
                Expanded(
                  child: _SessionTypeButton(
                    label: 'Physical',
                    isSelected: sessionType == SessionType.physical,
                    onTap: () {
                      context.read<TrainerProfileProvider>().setSessionType(
                        SessionType.physical,
                      );
                    },
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTypeButton extends StatelessWidget {
  const _SessionTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.text14Medium.copyWith(
              color: isSelected ? AppColors.background : AppColors.grey400,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final sessionPlan = provider.selectedSessionPlan;

    final price = sessionPlan?.feeAmount ?? 100.00;
    const tax = 0.00;
    final total = price + tax;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Info',
            style: AppTextStyle.text16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          _PaymentRow(label: 'Price', value: '\$${price.toStringAsFixed(2)}'),
          SizedBox(height: AppSpacing.xs),
          _PaymentRow(label: 'Tax', value: '\$${tax.toStringAsFixed(2)}'),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Total',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          _PaymentRow(
            label: 'Total Price',
            value: '\$${total.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.text16Regular.copyWith(color: AppColors.grey400),
        ),
        Text(
          value,
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BookSessionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final showBookingConfirmation = provider.showBookingConfirmation;
    final canBook = provider.canBookSession;

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
            : (showBookingConfirmation ? 'Confirm' : 'Book Session'),
        size: ButtonSize.large,
        width: double.infinity,
        height: 52.h,
        backgroundColor: showBookingConfirmation || canBook
            ? AppColors.primary
            : AppColors.grey300,
        textColor: AppColors.background,
        textStyle: AppTextStyle.text16SemiBold.copyWith(
          color: AppColors.background,
        ),
        borderRadius: 12.r,
        isEnabled: (showBookingConfirmation || canBook) && !provider.isBooking,
        onPressed: showBookingConfirmation
            ? () async {
                final provider = context.read<TrainerProfileProvider>();
                final success = await provider.bookSession();

                if (success && context.mounted) {
                  final sessionPlan = provider.selectedSessionPlan;
                  final totalAmount = sessionPlan?.feeAmount ?? 100.00;
                  final trainerId = provider.trainer?.id;
                  const paymentMethod = 'Apple Pay';
                  const cardNumber = 'email@website.com';

                  // Calculate session details
                  final trainerName =
                      provider.trainer?.fullName ??
                      provider.trainer?.fullName ??
                      'Trainer';
                  final selectedDateId = provider.selectedDate!;
                  final selectedTimeSlot = provider.selectedTimeSlot!;

                  final sessionDate = DateTimeUtils.formatDateId(
                    selectedDateId,
                    provider.availableDates,
                  );

                  // Calculate ISO start time
                  final timestamps = DateTimeUtils.convertToIsoTimestamps(
                    dateId: selectedDateId,
                    timeSlot: selectedTimeSlot,
                    availableDates: provider.availableDates,
                    durationMinutes: sessionPlan?.durationMinutes ?? 60,
                  );

                  final sessionStartTime = timestamps['startTime']!;

                  context.push(
                    '/transaction-successful?amount=${totalAmount.toStringAsFixed(2)}&paymentMethod=${Uri.encodeComponent(paymentMethod)}&cardNumber=${Uri.encodeComponent(cardNumber)}&trainerName=${Uri.encodeComponent(trainerName)}&sessionDate=${Uri.encodeComponent(sessionDate)}&sessionTime=${Uri.encodeComponent(selectedTimeSlot)}&sessionStartTime=${Uri.encodeComponent(sessionStartTime)}&bookingId=$trainerId}',
                  );
                } else if (context.mounted && provider.bookingError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.bookingError!,
                        style: AppTextStyle.text14Regular.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            : canBook
            ? () {
                context.read<TrainerProfileProvider>().showBookingView();
              }
            : null,
      ),
    );
  }
}
