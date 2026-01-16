import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/trainer_profile_provider.dart';

class TimeSlotSelector extends StatelessWidget {
  const TimeSlotSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final availableTimeSlots = provider.availableTimeSlots;

    if (availableTimeSlots.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
          child: Text(
            'Choose Time Slot',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 50.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableTimeSlots.length,
            padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
            separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final timeSlot = availableTimeSlots[index];
              return _TimeSlotButton(
                timeSlot: timeSlot,
                isSelected: provider.selectedTimeSlot == timeSlot,
                onTap: () {
                  provider.selectTimeSlot(timeSlot);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TimeSlotButton extends StatelessWidget {
  const _TimeSlotButton({
    required this.timeSlot,
    required this.isSelected,
    required this.onTap,
  });

  final String timeSlot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : AppColors.grey75,
          borderRadius: AppRadius.small,
        ),
        child: Center(
          child: Text(
            timeSlot,
            style: AppTextStyle.text14SemiBold.copyWith(
              color: isSelected ? AppColors.background : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}


