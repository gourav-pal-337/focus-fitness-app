import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/change_password_provider.dart';
import '../widgets/password_input_field.dart';
import '../widgets/password_update_success_dialog.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Change Password',
                centerTitle: true,
                actions: [
                  Consumer<ChangePasswordProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () {
                          provider.save();
                          PasswordUpdateSuccessDialog.show(
                            context: context,
                            onConfirm: () {
                              context.pop();
                            },
                          );
                        },
                        child: Icon(
                          Icons.check,
                          size: 24.sp,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.md),
                      Consumer<ChangePasswordProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: [
                              PasswordInputField(
                                label: 'Enter old password',
                                value: provider.oldPassword,
                                onChanged: (value) {
                                  provider.updateOldPassword(value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              PasswordInputField(
                                label: 'Enter New Password',
                                value: provider.newPassword,
                                onChanged: (value) {
                                  provider.updateNewPassword(value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              PasswordInputField(
                                label: 'Confirm New Password',
                                value: provider.confirmPassword,
                                onChanged: (value) {
                                  provider.updateConfirmPassword(value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                            ],
                          );
                        },
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

