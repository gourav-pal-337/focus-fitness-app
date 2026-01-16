import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

enum CancellationReason {
  tooExpensive,
  notUsingEnough,
  injuryHealthReason,
}

class CancelSubscriptionDialog extends StatefulWidget {
  const CancelSubscriptionDialog({
    super.key,
    required this.onCancel,
    required this.onKeepPlan,
  });

  final VoidCallback onCancel;
  final VoidCallback onKeepPlan;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onCancel,
    required VoidCallback onKeepPlan,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: true,
      builder: (context) => CancelSubscriptionDialog(
        onCancel: onCancel,
        onKeepPlan: onKeepPlan,
      ),
    );
  }

  @override
  State<CancelSubscriptionDialog> createState() =>
      _CancelSubscriptionDialogState();
}

class _CancelSubscriptionDialogState extends State<CancelSubscriptionDialog> {
  CancellationReason? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.xl,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.medium,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.left),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CancellationIcon(),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Why are you cancelling?',
                style: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'You will loose access to all premium features.',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.grey400,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              _ReasonRadioOption(
                reason: CancellationReason.tooExpensive,
                label: 'Too Expensive',
                selectedReason: _selectedReason,
                onChanged: (reason) {
                  setState(() {
                    _selectedReason = reason;
                  });
                },
              ),
              SizedBox(height: AppSpacing.md),
              _ReasonRadioOption(
                reason: CancellationReason.notUsingEnough,
                label: 'Not using it enough',
                selectedReason: _selectedReason,
                onChanged: (reason) {
                  setState(() {
                    _selectedReason = reason;
                  });
                },
              ),
              SizedBox(height: AppSpacing.md),
              _ReasonRadioOption(
                reason: CancellationReason.injuryHealthReason,
                label: 'Injury/Health reason',
                selectedReason: _selectedReason,
                onChanged: (reason) {
                  setState(() {
                    _selectedReason = reason;
                  });
                },
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      type: ButtonType.filled,
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onCancel();
                      },
                      textStyle: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.background,
                      ),
                      backgroundColor: Colors.red,
                      textColor: AppColors.background,
                      borderRadius: 12.r,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CustomButton(
                      text: 'Keep my plan',
                      type: ButtonType.outlined,
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onKeepPlan();
                      },
                      textStyle: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      borderColor: AppColors.grey300,
                      backgroundColor: AppColors.background,
                      textColor: AppColors.textPrimary,
                      borderRadius: 12.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancellationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.close,
        size: 40.sp,
        color: AppColors.background,
      ),
    );
  }
}

class _ReasonRadioOption extends StatelessWidget {
  const _ReasonRadioOption({
    required this.reason,
    required this.label,
    required this.selectedReason,
    required this.onChanged,
  });

  final CancellationReason reason;
  final String label;
  final CancellationReason? selectedReason;
  final ValueChanged<CancellationReason> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedReason == reason;

    return GestureDetector(
      onTap: () => onChanged(reason),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.red : AppColors.grey300,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

