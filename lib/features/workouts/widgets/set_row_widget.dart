import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/set_model.dart';

class SetRowWidget extends StatelessWidget {
  const SetRowWidget({super.key, required this.index, required this.set});

  final int index;
  final SetModel set;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: AppTextStyle.text14Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${set.reps}',
              textAlign: TextAlign.center,
              style: AppTextStyle.text14Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              set.weight?.toString() ?? '-',
              textAlign: TextAlign.center,
              style: AppTextStyle.text14Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
