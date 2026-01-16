import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../widgets/privacy_security_option.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Privacy & Security',
              centerTitle: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: AppSpacing.md),
                    PrivacySecurityOption(
                      label: 'Enable Two-Factor Authentication',
                      onTap: () {
                        context.push(TwoFactorAuthenticationRoute.path);
                      },
                    ),
                    Divider(
                      color: AppColors.grey200,
                      thickness: 1,
                      height: 0,
                    ),
                    PrivacySecurityOption(
                      label: 'Delete Account',
                      isDestructive: true,
                      onTap: () {
                        context.push(DeleteAccountRoute.path);
                      },
                    ),
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
    );
  }
}

