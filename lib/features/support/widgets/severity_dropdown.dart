import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/contact_support_provider.dart';

class SeverityDropdown extends StatelessWidget {
  const SeverityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSupportProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Severity',
              style: AppTextStyle.text14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            GestureDetector(
              onTap: () {
                _showSeveritySheet(context, provider);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.grey200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.priority_high_rounded,
                      size: 20.sp,
                      color: provider.severity.isEmpty
                          ? AppColors.grey400
                          : AppColors.primary,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        provider.severity.isEmpty
                            ? 'Select severity'
                            : provider.severity.split(' – ').first,
                        style: AppTextStyle.text16Regular.copyWith(
                          color: provider.severity.isEmpty
                              ? AppColors.grey400
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24.sp,
                      color: AppColors.grey400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSeveritySheet(
    BuildContext context,
    ContactSupportProvider provider,
  ) {
    final severities = [
      '🔴 Critical – Can’t complete task / money issue',
      '🟠 Medium – Works but incorrect',
      '🟢 Low – Minor / cosmetic',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Severity Level',
              style: AppTextStyle.text18SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: severities.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.grey100,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final severity = severities[index];
                  final isSelected = provider.severity == severity;
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4.h,
                    ),
                    title: Text(
                      severity,
                      style: AppTextStyle.text16Regular.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      provider.updateSeverity(severity);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
