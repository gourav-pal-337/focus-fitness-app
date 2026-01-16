import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PastSubscriptionItem extends StatelessWidget {
  const PastSubscriptionItem({
    super.key,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
  });

  final String planName;
  final String startDate;
  final String endDate;
  final String paymentMethod;

  String _getSubscriptionDetailsPath() {
    final uri = Uri(
      path: SubscriptionDetailsRoute.path,
      queryParameters: {
        'planName': planName,
        'startDate': startDate,
        'endDate': endDate,
        'paymentMethod': paymentMethod,
      },
    );
    return uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(_getSubscriptionDetailsPath());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubscriptionIcon(),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: AppTextStyle.text14Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Start Date: $startDate',
                  style: AppTextStyle.text10Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'End Date: $endDate',
                  style: AppTextStyle.text10Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          _PaymentMethodButton(paymentMethod: paymentMethod),
        ],
      ),
      ),
    );
  }
}

class _SubscriptionIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.fitness_center,
        size: 24.sp,
        color: AppColors.primary,
      ),
    );
  }
}

class _PaymentMethodButton extends StatelessWidget {
  const _PaymentMethodButton({required this.paymentMethod});

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey75,
        borderRadius: AppRadius.small,
      ),
      child: Text(
        paymentMethod,
        style: AppTextStyle.text10Regular.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

