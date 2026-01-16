import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class KnowMoreSection extends StatefulWidget {
  const KnowMoreSection({super.key});

  @override
  State<KnowMoreSection> createState() => _KnowMoreSectionState();
}

class _KnowMoreSectionState extends State<KnowMoreSection> {
  bool _isExpanded = false;

  static const String _fullText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';
  static const String _shortText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud...';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Know more',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          _isExpanded ? _fullText : _shortText,
          style: AppTextStyle.text14SemiBold.copyWith(
            color: AppColors.grey400,
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'less' : 'more',
            style: AppTextStyle.text14SemiBold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

