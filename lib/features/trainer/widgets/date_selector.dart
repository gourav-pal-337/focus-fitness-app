import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/trainer_profile_provider.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainerProfileProvider>();
    final availableDates = provider.availableDates;

    if (availableDates.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
          child: Text(
            'Choose Date',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
            itemCount: availableDates.length,
            separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final dateInfo = availableDates[index];
              return _DateCard(
                date: dateInfo.date,
                day: dateInfo.day,
                isSelected: provider.selectedDate == dateInfo.dateId,
                onTap: () {
                  provider.selectDate(dateInfo.dateId);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.date,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final String date;
  final String day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78.w,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : AppColors.grey75,
          borderRadius: AppRadius.small,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date,
              style: AppTextStyle.text24Bold.copyWith(
                color: isSelected ? AppColors.background : AppColors.grey400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              day,
              style: AppTextStyle.text14Regular.copyWith(
                color: isSelected ? AppColors.background : AppColors.grey400,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  width: 4.w,
                  height: 4.w,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.background : AppColors.grey400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


