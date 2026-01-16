import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/contact_support_provider.dart';

class SubjectInputField extends StatelessWidget {
  const SubjectInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactSupportProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject',
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.small,
                border: Border.all(
                  color: AppColors.grey200,
                  width: 1,
                ),
              ),
              child: TextField(
                onChanged: provider.updateSubject,
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter a short title of your issue',
                  hintStyle: AppTextStyle.text16Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(AppSpacing.md),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

