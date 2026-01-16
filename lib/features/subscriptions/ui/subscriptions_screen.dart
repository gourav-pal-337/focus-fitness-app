import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_sliver_app_bar.dart';
import '../provider/subscription_provider.dart';
import '../widgets/cancel_subscription_dialog.dart';
import '../widgets/manage_subscription_button.dart';
import '../widgets/subscription_cancelled_dialog.dart';
import '../widgets/subscription_features_list.dart';
import '../widgets/subscription_options_menu.dart';
import '../widgets/subscription_plan_cards.dart';
import '../widgets/subscription_plan_header.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscriptionProvider(),
      child: Scaffold(
      backgroundColor: AppColors.background,
        body: CustomScrollView(
          
          slivers: [
            CustomSliverAppBar(
              onBack: () {
                context.go(HomeRoute.path);
              },
              expandedHeight: 150.h,
              title: 'Subscription',
              backgroundImage:
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
              actions: [
                SubscriptionOptionsMenu.buildMenuButton(
                  onViewHistory: () {
                    context.push(PastSubscriptionsRoute.path);
                  },
                  onCancelSubscription: () {
                    CancelSubscriptionDialog.show(
                      context: context,
                      onCancel: () {
                        SubscriptionCancelledDialog.show(
                          context: context,
                          onReactivate: () {
                            // TODO: Handle reactivate subscription
                          },
                        );
                      },
                      onKeepPlan: () {
                        // User chose to keep the plan - no action needed
                      },
                    );
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.left),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: AppSpacing.xl),
                  const SubscriptionPlanHeader(),
                  SizedBox(height: AppSpacing.xl),
                  const SubscriptionPlanCards(),
                  SizedBox(height: AppSpacing.xl),
                  const SubscriptionFeaturesList(),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const ManageSubscriptionButton(),
      ),
    );
  }
}
