import 'package:flutter/material.dart';
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
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                _showIssueTypeDialog(context, provider);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.small,
                  border: Border.all(
                    color: AppColors.grey200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 20.sp,
                      color: AppColors.grey400,
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
                      Icons.keyboard_arrow_down,
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

  void _showIssueTypeDialog(
    BuildContext context,
    ContactSupportProvider provider,
  ) {
    final issueTypes = [
      'Technical Issue',
      'Billing Issue',
      'Account Issue',
      'Feature Request',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
        ),
        title: Text(
          'Select Issue Type',
          style: AppTextStyle.text18SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: issueTypes.map((type) {
            return ListTile(
              title: Text(
                type,
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                provider.updateIssueType(type);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}


