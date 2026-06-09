import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/app_modal_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/contact_support_provider.dart';

class IssueTypeDropdown extends StatelessWidget {
  const IssueTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSupportProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Issue Type',
              style: AppTextStyle.text14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            GestureDetector(
              onTap: () {
                _showIssueTypeSheet(context, provider);
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
                      _getIssueIcon(provider.issueType),
                      size: 20.sp,
                      color: provider.issueType.isEmpty
                          ? AppColors.grey400
                          : AppColors.primary,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        provider.issueType.isEmpty
                            ? 'Select issue type'
                            : provider.issueType,
                        style: AppTextStyle.text16Regular.copyWith(
                          color: provider.issueType.isEmpty
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

  IconData _getIssueIcon(String type) {
    switch (type) {
      case 'Bug / Not working':
        return Icons.bug_report_outlined;
      case 'Payment':
        return Icons.payment_outlined;
      case 'Chat':
        return Icons.chat_bubble_outline_rounded;
      case 'Bookings':
        return Icons.calendar_today_outlined;
      case 'Account':
        return Icons.person_outline_rounded;
      case 'Other':
        return Icons.help_outline_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  void _showIssueTypeSheet(
    BuildContext context,
    ContactSupportProvider provider,
  ) {
    final issueTypes = [
      'Bug / Not working',
      'Payment',
      'Chat',
      'Bookings',
      'Account',
      'Other'
    ];

    showAppModalSheet(
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
              'Issue Type',
              style: AppTextStyle.text18SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: issueTypes.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.grey100,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final type = issueTypes[index];
                  final isSelected = provider.issueType == type;
                  return ListTile(
                    leading: Icon(
                      _getIssueIcon(type),
                      color: isSelected ? AppColors.primary : AppColors.grey400,
                      size: 22.sp,
                    ),
                    title: Text(
                      type,
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
                      provider.updateIssueType(type);
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
