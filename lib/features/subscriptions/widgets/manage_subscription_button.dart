import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../provider/subscription_provider.dart';

class ManageSubscriptionButton extends StatelessWidget {
  const ManageSubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();
    final selectedPlan = provider.selectedPlan;

    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Typically we would check if user has an active subscription.
          // Since we are showing offers, we can show the selected plan details
          if (selectedPlan != null)
            Text(
              'Selected Plan: ${selectedPlan.title} (${AppConstants.currencySymbol}${selectedPlan.amount})',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: AppSpacing.md),
          CustomButton(
            text: provider.isCheckingOut
                ? 'Loading...'
                : "Subscriptions will be live shortly", //'Proceed to Checkout',
            type: ButtonType.filled,
            onPressed: provider.isCheckingOut
                ? () {} // Disable click while loading
                : () {
                    if (selectedPlan != null) {
                      final trainerId =
                          provider.trainer?.id ?? '65b82a17f3c74b00018a1b2c';
                      final amount = selectedPlan.amount.toStringAsFixed(2);
                      final planType = selectedPlan.planType;

                      context.push(
                        '/payment-method?amount=$amount&trainerId=$trainerId&isSubscription=true&planType=$planType',
                      );
                    }
                  },
            width: double.infinity,
            backgroundColor: AppColors.primary,
            textColor: AppColors.background,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
