import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SubscriptionDetailsCard extends StatelessWidget {
  const SubscriptionDetailsCard({
    super.key,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    this.onDownloadInvoice,
  });

  final String planName;
  final String startDate;
  final String endDate;
  final String paymentMethod;
  final VoidCallback? onDownloadInvoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.2),
            blurRadius: 10,
            // offset: Offset(10, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlanHeader(planName: planName),
          SizedBox(height: AppSpacing.md),
          _Divider(),
          SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Start Date', value: startDate),
          SizedBox(height: AppSpacing.md),
          _Divider(),
          SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'End Date', value: endDate),
          SizedBox(height: AppSpacing.md),
          _Divider(),
          SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Payment Method', value: paymentMethod),
          SizedBox(height: AppSpacing.md),
          _Divider(),
          SizedBox(height: AppSpacing.md),
          _DownloadInvoiceRow(onTap: onDownloadInvoice),
        ],
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget {
  const _PlanHeader({required this.planName});

  final String planName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.fitness_center,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Text(
          planName,
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.grey300,
      height: 1,
      thickness: 1,
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _DownloadInvoiceRow extends StatelessWidget {
  const _DownloadInvoiceRow({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Download Invoice',
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 24.sp,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

