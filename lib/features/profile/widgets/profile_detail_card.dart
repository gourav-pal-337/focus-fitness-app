import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileDetailCard extends StatelessWidget {
  const ProfileDetailCard({
    super.key,
    required this.items,
    required this.onEdit,
  });

  final List<ProfileDetailItem> items;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
            // offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                _DetailRow(
                  label: entry.value.label,
                  value: entry.value.value,
                ),
                if (!isLast)
                  Divider(
                    color: AppColors.grey200,
                    thickness: 1,
                    height: 0,
                  ),
              ],
            );
          }),
          // SizedBox(height: AppSpacing.md),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
            height: 0,
          ),
          // SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: onEdit,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h,horizontal: AppSpacing.md),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Edit',
                    style: AppTextStyle.text14Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailItem {
  const ProfileDetailItem({
    required this.label,
    this.value,
  });

  final String label;
  final String? value;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? 'Not set';
    final isPlaceholder = value == null || (value?.isEmpty ?? true);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h,horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.text16Regular.copyWith(
              color: AppColors.grey400,
            ),
          ),
          Text(
            displayValue,
            style: AppTextStyle.text16Regular.copyWith(
              color: isPlaceholder
                  ? AppColors.grey400
                  : AppColors.textPrimary,
              fontStyle: isPlaceholder ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}

