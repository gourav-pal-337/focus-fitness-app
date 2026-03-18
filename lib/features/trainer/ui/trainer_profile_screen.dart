import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/features/home/widgets/trainer_summary_section.dart';
import 'package:focus_fitness/features/trainer/data/models/trainer_referral_response_model.dart';
import 'package:focus_fitness/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/payment_breakdown_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/date_time_bar.dart';
import '../provider/trainer_profile_provider.dart';
import '../provider/system_settings_provider.dart';
import '../utils/date_time_utils.dart';
import '../widgets/trainer_profile_header.dart';
import '../widgets/trainer_info_section.dart';
import '../widgets/trainer_stats_row.dart';
import '../widgets/date_selector.dart';
import '../widgets/time_slot_selector.dart';

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({super.key, required this.trainerInfo});

  final TrainerInfo? trainerInfo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TrainerProfileProvider()..fetchTrainerProfile(trainerInfo!.id),
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
                  TrainerProfileHeader(
                    trainerImageUrl: trainerInfo?.profilePhoto,
                  ),
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
                      //                       const TrainerProfileScreen({
                      //   super.key,
                      //   required this.trainerId,
                      //   this.trainerName = 'James Gustavsson',
                      //   this.trainerSpecialty = 'HIIT & Cardio',
                      //   this.trainerRating = 4.6,
                      //   this.trainerImageUrl,
                      // });

                      final trainer = provider.trainer;
                      if (trainer == null) {
                        return TrainerInfoSection(
                          name: trainerInfo?.fullName ?? "trainer",
                          specialty: "HIIT & Cardio",
                          rating: 4.6,
                          imageUrl: trainerInfo?.profilePhoto ?? "",
                        );
                      }

                      return TrainerInfoSection(
                        name: trainer.fullName ?? "trainer",
                        specialty: trainer.expertiseAreas.isNotEmpty
                            ? trainer.expertiseAreas.join(' & ')
                            : "HIIT & Cardio",
                        rating: trainer.avgRating ?? 4.6,
                        imageUrl: trainer.profilePhoto ?? "",
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
    final provider = context.watch<TrainerProfileProvider>();
    final sessionPlan = provider.selectedSessionPlan;

    return Column(
      children: [
        _SessionDateTimeDisplay(),
        SizedBox(height: AppSpacing.xl),
        _SessionTypeSelector(),
        SizedBox(height: AppSpacing.xl),
        if (sessionPlan != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding.left,
            ),
            child: PaymentBreakdownWidget(sessionPrice: sessionPlan.feeAmount),
          ),
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
                    label: 'Online Mode',
                    isSelected: sessionType == SessionType.online,
                    onTap: () {
                      context.read<TrainerProfileProvider>().setSessionType(
                        SessionType.online,
                      );
                    },
                    borderRadius: BorderRadius.circular(5.r),
                    // .only(
                    //   topLeft: Radius.circular(12.r),
                    //   bottomLeft: Radius.circular(12.r),
                    // ),
                  ),
                ),
                // Expanded(
                //   child: _SessionTypeButton(
                //     label: 'Physical',
                //     isSelected: sessionType == SessionType.physical,
                //     onTap: () {
                //       context.read<TrainerProfileProvider>().setSessionType(
                //         SessionType.physical,
                //       );
                //     },
                //     borderRadius: BorderRadius.only(
                //       topRight: Radius.circular(12.r),
                //       bottomRight: Radius.circular(12.r),
                //     ),
                //   ),
                // ),
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

class _BookSessionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final settingsProvider = context.watch<SystemSettingsProvider>();
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
                final sessionPlan = provider.selectedSessionPlan;
                final baseAmount = sessionPlan?.feeAmount ?? 100.00;
                final totalAmount = settingsProvider.calculateTotalAmount(
                  baseAmount,
                );
                final trainerId = provider.trainer?.id ?? '';
                final sessionPlanId = sessionPlan?.id ?? '';
                final dateId = provider.selectedDate ?? '';
                final timeSlot = provider.selectedTimeSlot ?? '';
                final durationMinutes = sessionPlan?.durationMinutes ?? 60;

                final uri = Uri(
                  path: PaymentMethodRoute.path,
                  queryParameters: {
                    if (trainerId.isNotEmpty) 'trainerId': trainerId,
                    if (sessionPlanId.isNotEmpty)
                      'sessionPlanId': sessionPlanId,
                    if (dateId.isNotEmpty) 'dateId': dateId,
                    if (timeSlot.isNotEmpty) 'timeSlot': timeSlot,
                    'amount': totalAmount.toStringAsFixed(2),
                    'baseAmount': baseAmount.toStringAsFixed(2),
                    'durationMinutes': durationMinutes.toString(),
                    'trainerName': provider.trainer?.fullName ?? 'Trainer',
                    'sessionDate': DateTimeUtils.formatDateId(
                      dateId,
                      provider.availableDates,
                    ),
                    'sessionTime': timeSlot,
                    'sessionStartTime':
                        DateTimeUtils.convertToIsoTimestamps(
                          dateId: dateId,
                          timeSlot: timeSlot,
                          availableDates: provider.availableDates,
                          durationMinutes: durationMinutes,
                        )['startTime'] ??
                        '',
                  },
                ).toString();

                context.push(uri);
              }
            : canBook
            ? () {
                // Fetch settings when entering booking view to ensure total is calculated correctly
                context.read<SystemSettingsProvider>().fetchFeeSettings();
                context.read<TrainerProfileProvider>().showBookingView();
              }
            : null,
      ),
    );
  }
}
