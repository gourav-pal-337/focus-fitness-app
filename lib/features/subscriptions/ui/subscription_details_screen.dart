import 'package:flutter/material.dart';
import 'package:focus_fitness/core/theme/app_spacing.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../widgets/subscription_details_card.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Subscription Details',
            ),
            SizedBox(height: AppSpacing.md),
            Center(
              child: SubscriptionDetailsCard(
                planName: planName,
                startDate: startDate,
                endDate: endDate,
                paymentMethod: paymentMethod,
                onDownloadInvoice: () {
                  // TODO: Handle download invoice
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

