import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../../../routes/app_router.dart';
import '../../../trainer/provider/linked_trainer_provider.dart';
import '../../provider/auth_provider.dart';

class LinkTrainerScreen extends StatelessWidget {
  const LinkTrainerScreen({
    super.key,
    required this.trainerId,
  });

  final String trainerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildContent(context),
              // _buildVerifyButton(context),
            ],
          ),
        ),
        floatingActionButton: _buildVerifyButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding.left,
        right: AppSpacing.screenPadding.right,
        top: AppSpacing.md,
        bottom: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Center(
            child: Text(
              'Link Trainer',
              style: AppTextStyle.text20SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final trainer = provider.foundTrainer;
        final trainerName = trainer?.fullName ?? 'Trainer';
        final trainerImageUrl = trainer?.profilePhoto;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding.left,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48.r,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: trainerImageUrl != null
                      ? NetworkImage(trainerImageUrl)
                      : null,
                  child: trainerImageUrl == null
                      ? Icon(
                          Icons.person,
                          size: 40.sp,
                          color: AppColors.grey400,
                        )
                      : null,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  trainerName,
                  style: AppTextStyle.text24SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Trainer ID: $trainerId',
                  style: AppTextStyle.text16Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return Consumer2<AuthProvider, UserProvider>(
      builder: (context, authProvider, userProvider, _) {
        final isLoading = authProvider.isLinkingTrainer;
        final error = authProvider.linkTrainerError;
        final trainer = authProvider.foundTrainer;
        final trainerName = trainer?.fullName ?? 'Trainer';
        final trainerImageUrl = trainer?.profilePhoto;

        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            top: AppSpacing.lg,
            bottom: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              // Show error message if linking failed
              if (error != null)
                Container(
                  margin: EdgeInsets.only(bottom: AppSpacing.md),
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          error,
                          style: AppTextStyle.text14Regular.copyWith(
                            color: Colors.red,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              CustomButton(
                text: isLoading ? 'Linking...' : 'Verify',
                size: ButtonSize.large,
                width: double.infinity,
                height: 52.h,
                backgroundColor:
                    isLoading ? AppColors.grey300 : AppColors.primary,
                textColor: AppColors.background,
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                borderRadius: 12.r,
                isEnabled: !isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        // Get user info from UserProvider or AuthProvider
                        final fullName = userProvider.user?.fullName ??
                            authProvider.name;
                        final email = userProvider.user?.email;
                        final phone = userProvider.user?.phone ??
                            (authProvider.phoneNumber.isNotEmpty
                                ? '${authProvider.countryCode}${authProvider.phoneNumber}'
                                : null);

                        // Link trainer
                        final success = await authProvider.linkTrainer(
                          fullName: trainerName,
                          preferredName: trainerName,
                          // email: email,
                          phone: userProvider.user?.phone ?? '',
                        );

                        if (success && context.mounted) {
                          // Refresh linked trainer data
                          _showSuccessModal(context);
                          final linkedTrainerProvider = context.read<LinkedTrainerProvider>();
                          await linkedTrainerProvider.refresh();
                        }
                        // Error is already shown in the error container above
                      },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _SuccessModal(
        onContinue: () {
          Navigator.of(context).pop();
          context.go(HomeRoute.path);
        },
      ),
    );
  }
}

class _SuccessModal extends StatelessWidget {
  const _SuccessModal({
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
      ),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.large,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 48.sp,
                color: AppColors.green,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'You are now linked with your trainer.',
              textAlign: TextAlign.center,
              style: AppTextStyle.text18SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.lg * 1.5),
            CustomButton(
              text: 'Continue',
              size: ButtonSize.large,
              width: double.infinity,
              height: 52.h,
              backgroundColor: AppColors.primary,
              textColor: AppColors.background,
              textStyle: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.background,
              ),
              borderRadius: 12.r,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

