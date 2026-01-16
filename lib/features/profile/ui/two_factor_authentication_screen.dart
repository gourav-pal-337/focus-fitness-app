import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/two_factor_auth_provider.dart';

class TwoFactorAuthenticationScreen extends StatelessWidget {
  const TwoFactorAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = TwoFactorAuthProvider();
        provider.initialize();
        return provider;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Two-Factor Authentication',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.md),
                      Consumer<TwoFactorAuthProvider>(
                        builder: (context, provider, child) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenPadding.left,
                            ),
                            child: Row(
                              children: [
                                Switch(
                                  value: provider.isEnabled,
                                  onChanged: provider.isLoading
                                      ? null
                                      : (value) {
                                    provider.toggle();
                                  },
                                  activeColor: AppColors.primary,
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Enable Two-Factor Authentication',
                                        style: AppTextStyle.text16Regular.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Adds extra security when logging in.',
                                        style: AppTextStyle.text14Regular.copyWith(
                                          color: AppColors.grey400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.md),

                      Divider(
                        color: AppColors.grey200,
                        thickness: 1,
                        height: 0,
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

