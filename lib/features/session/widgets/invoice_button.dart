import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/file_opener_widget.dart';

class InvoiceButton extends StatelessWidget {
  const InvoiceButton({
    super.key,
    required this.invoiceUrl,
  });

  final String invoiceUrl;

  @override
  Widget build(BuildContext context) {
    return FileOpenerWidget(
      url: invoiceUrl,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textPrimary.withValues( alpha: 0.6),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 20.sp,
              color: AppColors.textPrimary,
            ),
            SizedBox(width: AppSpacing.xs + 2.w),
            Text(
              'View Invoice',
              style: AppTextStyle.text14Medium.copyWith(
                color: AppColors.textPrimary.withValues( alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

