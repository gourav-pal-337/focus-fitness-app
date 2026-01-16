import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../provider/auth_provider.dart';
import 'widgets/trainer_list_widget.dart';
import 'widgets/trainer_search_field.dart';

class EnterTrainerIdScreen extends StatelessWidget {
  const EnterTrainerIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    // Can proceed if trainer is selected or if input is not empty (will search on click)
    final canProceed = authProvider.isTrainerValid || authProvider.canProceedWithTrainerId;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            bottom: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Enter trainer referral code',
                style: AppTextStyle.text32Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Please enter trainer name or referral code',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              const TrainerSearchField(),
              SizedBox(height: AppSpacing.md),
              const _TrainerValidationInfo(),
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.only(
          left: AppSpacing.screenPadding.left,
          right: AppSpacing.screenPadding.right,
          bottom: AppSpacing.lg,
        ),
                text: 'Next',
                size: ButtonSize.large,
                width: double.infinity,
                height: 52.h,
                backgroundColor: canProceed ? AppColors.primary : AppColors.grey300,
                // Light blue color from design
                textColor: AppColors.background,
                icon: Icon(
                  Icons.arrow_forward,
                  size: 20.sp,
                  color: AppColors.background,
                ),
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                iconPosition: IconPosition.right,
                borderRadius: 12.r,
                isEnabled: canProceed,
                onPressed: canProceed
                    ? () async {
                        final provider = context.read<AuthProvider>();
                        
                        // If trainer is already selected, navigate directly
                        if (provider.isTrainerValid && provider.selectedTrainer != null) {
                          final trainerId = provider.selectedTrainer!.referralCode;
                          context.push('/link-trainer/$trainerId');
                          return;
                        }
                        
                        // If trainers found but none selected, show error
                        if (provider.hasTrainers && provider.selectedTrainer == null) {
                          // Error will be shown in _TrainerValidationInfo
                          return;
                        }
                        
                        // Otherwise, search trainer by referral code
                        final trainerId = provider.trainerId.trim();
                        await provider.searchTrainer(trainerId);
                        
                        // Check if trainer was selected (auto-selected if only one found)
                        if (provider.isTrainerValid && provider.selectedTrainer != null) {
                          // Navigate to link trainer screen - trainer info is in provider
                          context.push('/link-trainer/${provider.selectedTrainer!.referralCode}');
                        }
                        // If search failed, error will be shown in _TrainerValidationInfo
                      }
                    : null,
              ),
    );
  }
}


class _TrainerValidationInfo extends StatelessWidget {
  const _TrainerValidationInfo();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    // Show loading indicator while searching
    if (provider.isValidatingTrainer) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Searching trainer...',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

   
    

    // Show error message if search failed
    if (provider.trainerValidationError != null) {
      return Container(
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
                provider.trainerValidationError!,
                style: AppTextStyle.text14Regular.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
