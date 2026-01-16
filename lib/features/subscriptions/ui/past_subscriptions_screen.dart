import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../widgets/past_subscription_item.dart';

class PastSubscriptionsScreen extends StatelessWidget {
  const PastSubscriptionsScreen({super.key});

  static final List<_PastSubscriptionData> _pastSubscriptions = [
    _PastSubscriptionData(
      planName: 'Weekly Plan',
      startDate: 'September 15, 2025',
      endDate: 'September 22, 2025',
      paymentMethod: 'Credit Card',
    ),
    _PastSubscriptionData(
      planName: 'Monthly Plan',
      startDate: 'August 13, 2025',
      endDate: 'September 13, 2025',
      paymentMethod: 'Credit Card',
    ),
    _PastSubscriptionData(
      planName: 'Monthly Plan',
      startDate: 'July 13, 2025',
      endDate: 'August 12, 2025',
      paymentMethod: 'Credit Card',
    ),
    _PastSubscriptionData(
      planName: 'Annual Plan',
      startDate: 'January 1, 2024',
      endDate: 'December 31, 2024',
      paymentMethod: 'Credit Card',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Past Subscriptions',
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                itemCount: _pastSubscriptions.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.grey300,
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final subscription = _pastSubscriptions[index];
                  return PastSubscriptionItem(
                    planName: subscription.planName,
                    startDate: subscription.startDate,
                    endDate: subscription.endDate,
                    paymentMethod: subscription.paymentMethod,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PastSubscriptionData {
  const _PastSubscriptionData({
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
  });

  final String planName;
  final String startDate;
  final String endDate;
  final String paymentMethod;
}

