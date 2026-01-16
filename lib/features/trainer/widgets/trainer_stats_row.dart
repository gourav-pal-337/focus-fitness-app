import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TrainerStatsRow extends StatelessWidget {
  const TrainerStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          value: '25',
          label: 'Reviews',
        ),
        _StatItem(
          value: '3',
          label: 'Years exp.',
        ),
        _StatItem(
          value: '32',
          label: 'Clients',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.text20SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.text12SemiBold.copyWith(
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }
}

