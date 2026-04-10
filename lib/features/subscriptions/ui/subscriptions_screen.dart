import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_sliver_app_bar.dart';
import '../../trainer/provider/linked_trainer_provider.dart';
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
      create: (context) {
        final linkedTrainerState = context.read<LinkedTrainerProvider>();
        final trainerId =
            linkedTrainerState.trainer?.id ?? '65b82a17f3c74b00018a1b2c';

        final provider = SubscriptionProvider();
        provider.fetchOffers(trainerId);
        return provider;
      },
      child: Stack(
        children: [
          // Greyscale Layer of the Original UI
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Opacity(
              opacity: 0.5,
              child: IgnorePointer(
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
              ),
            ),
          ),

          // Functional Back Button Layer
          // SafeArea(
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       left: AppSpacing.screenPadding.left,
          //       top: 10.h,
          //     ),
          //     child: Material(
          //       color: Colors.transparent,
          //       child: InkWell(
          //         borderRadius: BorderRadius.circular(50),
          //         onTap: () => context.go(HomeRoute.path),
          //         child: Container(
          //           padding: const EdgeInsets.all(8),
          //           decoration: BoxDecoration(
          //             color: Colors.black.withOpacity(0.5),
          //             shape: BoxShape.circle,
          //           ),
          //           child: Icon(
          //             Icons.arrow_back,
          //             color: Colors.white,
          //             size: 24.sp,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // // Coming Soon Badge Overlay
          // Center(
          //   child: IgnorePointer(
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          //       decoration: BoxDecoration(
          //         color: Colors.black.withOpacity(0.85),
          //         borderRadius: BorderRadius.circular(20.r),
          //         border: Border.all(color: AppColors.primary, width: 2),
          //         boxShadow: [
          //           BoxShadow(
          //             color: AppColors.primary.withOpacity(0.4),
          //             blurRadius: 30,
          //             spreadRadius: 5,
          //           ),
          //         ],
          //       ),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text(
          //             'SOON',
          //             style: AppTextStyle.text28Bold.copyWith(
          //               color: AppColors.primary,
          //               letterSpacing: 4.0,
          //             ),
          //           ),
          //           SizedBox(height: 8.h),
          //           Text(
          //             'Subscriptions will be live shortly',
          //             style: AppTextStyle.text14Medium.copyWith(
          //               color: Colors.white,
          //               letterSpacing: 0.5,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
