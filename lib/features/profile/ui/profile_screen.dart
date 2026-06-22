import 'dart:io';
import 'package:flutter/material.dart';
import 'package:focus_fitness/core/service/local_storage_service.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
import 'package:focus_fitness/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading/background_refresh_indicator.dart';
import '../widgets/fitness_goals_section.dart';
import '../widgets/personal_details_section.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/subscription_section.dart';
import '../widgets/support_settings_section.dart';
import '../widgets/trainer_information_section.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String _appVersion = '1.0.0 (1)';

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ClientProfileProvider>(
        context,
        listen: false,
      );
      profileProvider.fetchProfile();
    });
  }

  Future<void> _onRefresh() async {
    final linkedTrainerProvider = Provider.of<LinkedTrainerProvider>(
      context,
      listen: false,
    );
    final profileProvider = Provider.of<ClientProfileProvider>(
      context,
      listen: false,
    );
    await Future.wait([
      linkedTrainerProvider.fetchLinkedTrainer(),
      profileProvider.fetchProfile(),
    ]);
  }

  Future<void> _fetchAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        });
        debugPrint('App version: $_appVersion');
      }
    } catch (e) {
      debugPrint('Error fetching app version: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Consumer2<ClientProfileProvider, LinkedTrainerProvider>(
              builder: (context, profileProvider, trainerProvider, _) {
                final isRefreshing =
                    profileProvider.isLoading || trainerProvider.isLoading;
                return CustomAppBar(
                  title: 'Profile',
                  actions: [
                    BackgroundRefreshIndicator(isRefreshing: isRefreshing),
                  ],
                );
              },
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
                            // SizedBox(height: AppSpacing.lg),
                            // SubscriptionSection(
                            //   plan: 'Premium Trainer Access',
                            //   nextBilling: '22 December 2025',
                            //   onManagePlans: () {
                            //     // TODO: Navigate to manage plans screen
                            //   },
                            // ),
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
                            _buildVersionInfo(),
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

  Widget _buildVersionInfo() {
    final platform = Platform.isIOS ? 'iOS' : 'Android';
    return Center(
      child: GestureDetector(
        onTap: () => _showVersionSummary(),
        child: Column(
          children: [
            Text(
              '$platform Version $_appVersion',
              style: AppTextStyle.text12Medium.copyWith(
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: 4.h),
            // Text(
            //   'View Release Summary',
            //   style: AppTextStyle.text10Regular.copyWith(
            //     color: AppColors.primary,
            //     decoration: TextDecoration.underline,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showVersionSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Version Summary', style: AppTextStyle.text18SemiBold),
            Text(
              'What\'s new in v$_appVersion',
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryItem(
              'Session Management',
              'Improved booking flow and trainer profile navigation.',
            ),
            _buildSummaryItem(
              'Authentication',
              'Enhanced registration with post-OTP verification record creation.',
            ),
            _buildSummaryItem(
              'UI/UX',
              'Premium dashboard cards and integrated session actions.',
            ),
            _buildSummaryItem(
              'Bug Fixes',
              'General performance improvements and stability updates.',
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
            size: ButtonSize.small,
            width: 100.w,
            borderRadius: 8.r,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyle.text14SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w),
            child: Text(
              description,
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
