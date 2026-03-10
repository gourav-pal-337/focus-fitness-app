import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';
import '../provider/subscription_provider.dart';
import 'subscription_plan_card.dart';

class SubscriptionPlanCards extends StatelessWidget {
  const SubscriptionPlanCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();
    final selectedPlan = provider.selectedPlan;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.offers.isEmpty) {
      return const Center(child: Text("No subscription offers available"));
    }

    return Row(
      children: provider.offers.asMap().entries.map((entry) {
        final index = entry.key;
        final offer = entry.value;
        final isLast = index == provider.offers.length - 1;

        // Define some UI tweaks based on interval or planType
        // For example, if it's "yearly", we might call it "Premium"
        String name = offer.interval == "year" ? "Premium" : "Popular";
        if (offer.interval == "week") name = "Standard";

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.sm),
            child: SubscriptionPlanCard(
              name: name,
              title: offer.title,
              price: '${AppConstants.currencySymbol}${offer.amount}',
              plan: offer,
              isSelected: selectedPlan?.planType == offer.planType,
              onTap: () {
                context.read<SubscriptionProvider>().selectPlan(offer);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
