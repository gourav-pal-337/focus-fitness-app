import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../provider/subscription_provider.dart';
import 'subscription_plan_card.dart';

class SubscriptionPlanCards extends StatelessWidget {
  const SubscriptionPlanCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();
    final selectedPlan = provider.selectedPlan;

    return Row(
      children: [
        Expanded(
          child: SubscriptionPlanCard(
            name: 'Standard',
            title: 'Weekly',
            price: '\$9.99',
            plan: SubscriptionPlan.weekly,
            isSelected: selectedPlan == SubscriptionPlan.weekly,
            onTap: () {
              context.read<SubscriptionProvider>().selectPlan(SubscriptionPlan.weekly);
            },
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SubscriptionPlanCard(
            name: 'Popular',
            title: 'Monthly',
            price: '\$34.99',
            plan: SubscriptionPlan.monthly,
            isSelected: selectedPlan == SubscriptionPlan.monthly,
            onTap: () {
              context.read<SubscriptionProvider>().selectPlan(SubscriptionPlan.monthly);
            },
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SubscriptionPlanCard(
            name: 'Premium',
            title: 'Annual',
            price: '\$349.99',
            plan: SubscriptionPlan.annual,
            isSelected: selectedPlan == SubscriptionPlan.annual,
            onTap: () {
              context.read<SubscriptionProvider>().selectPlan(SubscriptionPlan.annual);
            },
          ),
        ),
      ],
    );
  }
}

