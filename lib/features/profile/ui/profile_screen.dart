import 'package:flutter/material.dart';
import 'package:focus_fitness/core/service/local_storage_service.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
import 'package:focus_fitness/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../widgets/fitness_goals_section.dart';
import '../widgets/personal_details_section.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/subscription_section.dart';
import '../widgets/support_settings_section.dart';
import '../widgets/trainer_information_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ClientProfileProvider>(context, listen: false);
      profileProvider.fetchProfile();
    });
  }

  Future<void> _onRefresh() async {
    final linkedTrainerProvider = Provider.of<LinkedTrainerProvider>(context, listen: false);
    final profileProvider = Provider.of<ClientProfileProvider>(context, listen: false);
    await Future.wait([
      linkedTrainerProvider.fetchLinkedTrainer(),
      profileProvider.fetchProfile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              onBack: () {
                context.go(HomeRoute.path);
              },
              title: 'Profile',
              // centerTitle: true,
            ),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.xl),
                      ProfileHeaderSection(),
                      SizedBox(height: AppSpacing.xl),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding.left,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PersonalDetailsSection(),
                            SizedBox(height: AppSpacing.lg),
                            const FitnessGoalsSection(),
                            SizedBox(height: AppSpacing.lg),
                            TrainerInformationSection(
                              onDelink: () {
                                context.push(DelinkTrainerRoute.path);
                              },
                            ),
                            SizedBox(height: AppSpacing.lg),
                            SubscriptionSection(
                              plan: 'Premium Trainer Access',
                              nextBilling: '22 December 2025',
                              onManagePlans: () {
                                // TODO: Navigate to manage plans screen
                              },
                            ),
                            SizedBox(height: AppSpacing.lg),
                            SupportSettingsSection(
                              onLanguagePreferencesTap: () {
                                // TODO: Navigate to language preferences screen
                              },
                              onLogoutTap: () {
                                LocalStorageService.clearAll();
                                AppRouter.router.go(OnboardingRoute.path);

                                // TODO: Handle logout action
                              },
                            ),
                            SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
