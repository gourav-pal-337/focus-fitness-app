import 'package:flutter/material.dart';
import 'package:focus_fitness/features/support/widgets/contact_support_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/app_features_provider.dart';
import '../../../core/utils/feature_flag_utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../widgets/support_option_item.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Need Help?',
              centerTitle: true,
              onBack: () {
                context.go(HomeRoute.path);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: AppSpacing.sm),
                    // Text(
                    //   'We\'re here for you!\nIf you\'re facing an issue or have a question, just reach out and our support team will get back to you ASAP.',
                    //   style: AppTextStyle.text12Regular.copyWith(
                    //     color: AppColors.grey400,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    // SizedBox(height: AppSpacing.xl),
                    SupportOptionItem(
                      icon: Icons.help_outline,
                      title: 'FAQs',
                      description: 'View frequently asked questions',
                      onTap: () {
                        if (context
                            .read<AppFeaturesProvider>()
                            .isFaqSystemEnabled) {
                          context.push(FaqsRoute.path);
                        } else {
                          FeatureFlagUtils.showFeatureDisabledBottomSheet(
                            context,
                            title: 'Coming Soon',
                            message:
                                'FAQs are currently under maintenance. Please check back later.',
                          );
                        }
                      },
                    ),
                    Divider(color: AppColors.grey200, thickness: 1, height: 0),
                    SupportOptionItem(
                      icon: Icons.add_comment,
                      title: 'Contact Support',
                      description: 'Create Support Ticket',
                      onTap: () {
                        if (context
                            .read<AppFeaturesProvider>()
                            .isSupportTicketsEnabled) {
                          context.push(ContactSupportRoute.path);
                        } else {
                          FeatureFlagUtils.showFeatureDisabledBottomSheet(
                            context,
                            title: 'Coming Soon',
                            message:
                                'Support tickets are currently under maintenance. Please check back later.',
                          );
                        }
                      },
                    ),

                    // Divider(color: AppColors.grey200, thickness: 1, height: 0),
                    // SupportOptionItem(
                    //   icon: Icons.receipt_long_outlined,
                    //   title: 'Billing & Subscriptions',
                    //   description: 'Billing & subscription settings.',
                    //   onTap: () {
                    //     context.go(SubscriptionsRoute.path);
                    //   },
                    // ),
                    Divider(color: AppColors.grey200, thickness: 1, height: 0),
                    SupportOptionItem(
                      icon: Icons.check_circle_outline,
                      title: 'Track Ticket Status',
                      description: 'Track your ticket status here.',
                      onTap: () {
                        if (context
                            .read<AppFeaturesProvider>()
                            .isSupportTicketsEnabled) {
                          ContactSupportBottomSheet.show(
                            context: context,
                            onCreateTicketTap: () {
                              context.push(ContactSupportRoute.path);
                            },
                            onTrackTicketStatusTap: () {
                              context.push(TrackTicketRoute.path);
                            },
                          );
                        } else {
                          FeatureFlagUtils.showFeatureDisabledBottomSheet(
                            context,
                            title: 'Coming Soon',
                            message:
                                'Support tickets are currently under maintenance. Please check back later.',
                          );
                        }
                      },
                    ),
                    Divider(color: AppColors.grey200, thickness: 1, height: 0),
                    SupportOptionItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Use',
                      description: 'Review our terms of use',
                      onTap: () {
                        context.pushNamed(
                          LegalRoute.name,
                          queryParameters: {
                            'type': 'client_terms_of_use',
                            'title': 'Terms of Use',
                          },
                        );
                      },
                    ),

                    Divider(color: AppColors.grey200, thickness: 1, height: 0),

                    SupportOptionItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      description: 'Review our privacy policy',
                      onTap: () {
                        context.pushNamed(
                          LegalRoute.name,
                          queryParameters: {
                            'type': 'privacy_policy',
                            'title': 'Privacy Policy',
                          },
                        );
                      },
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding.left,
                      ),
                      child: Text(
                        'We\'re here for you!\nIf you\'re facing an issue or have a question, just reach out and our support team will get back to you ASAP.',
                        style: AppTextStyle.text12Regular.copyWith(
                          color: AppColors.grey400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
