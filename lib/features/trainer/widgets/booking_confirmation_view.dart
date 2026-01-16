import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/trainer_profile_provider.dart';
import '../utils/date_time_utils.dart';
import 'trainer_profile_header.dart';
import 'trainer_info_section.dart';

class BookingConfirmationView extends StatelessWidget {
  const BookingConfirmationView({
    super.key,
    required this.trainerName,
    required this.trainerSpecialty,
    required this.trainerRating,
    this.trainerImageUrl,
  });

  final String trainerName;
  final String trainerSpecialty;
  final double trainerRating;
  final String? trainerImageUrl;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            TrainerProfileHeader(
              trainerImageUrl: trainerImageUrl,
              onBack: () {
                context.read<TrainerProfileProvider>().hideBookingView();
              },
            ),
            SizedBox(height: 50.h),
            TrainerInfoSection(
              name: trainerName,
              specialty: trainerSpecialty,
              rating: trainerRating,
              imageUrl: trainerImageUrl,
            ),
            SizedBox(height: AppSpacing.xl),
            _SessionDateTimeDisplay(),
            SizedBox(height: AppSpacing.xl),
            _SessionTypeSelector(),
            SizedBox(height: AppSpacing.xl),
            _PaymentInfoSection(),
            SizedBox(height: AppSpacing.xl + 20.h),
          ]),
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

    if (selectedDate == null || selectedTimeSlot == null) {
      return const SizedBox.shrink();
    }

    // Format date using the dateId
    final formattedDate = _formatDate(provider, selectedDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grey75,
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              formattedDate,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            selectedTimeSlot,
            style: AppTextStyle.text16Regular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(TrainerProfileProvider provider, String dateId) {
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
            style: AppTextStyle.text20SemiBold.copyWith(
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
            style: AppTextStyle.text16SemiBold.copyWith(
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
    const price = 100.00;
    const tax = 0.00;
    final total = price + tax;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Info',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _PaymentRow(
            label: 'Price',
            value: '\$${price.toStringAsFixed(2)}',
          ),
          SizedBox(height: AppSpacing.sm),
          _PaymentRow(
            label: 'Tax',
            value: '\$${tax.toStringAsFixed(2)}',
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Total',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
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
  const _PaymentRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.text16Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.text16Regular.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

