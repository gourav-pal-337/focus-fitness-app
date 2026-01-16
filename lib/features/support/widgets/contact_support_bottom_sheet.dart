import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'support_option_item.dart';

class ContactSupportBottomSheet extends StatelessWidget {
  const ContactSupportBottomSheet({
    super.key,
    required this.onCreateTicketTap,
    required this.onTrackTicketStatusTap,
  });

  final VoidCallback onCreateTicketTap;
  final VoidCallback onTrackTicketStatusTap;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onCreateTicketTap,
    required VoidCallback onTrackTicketStatusTap,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ContactSupportBottomSheet(
        onCreateTicketTap: onCreateTicketTap,
        onTrackTicketStatusTap: onTrackTicketStatusTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left).copyWith(top: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.close,
                    size: 24.sp,
                    color: Colors.transparent,
                  ),
                  Text(
                    'Contact Support',
                    style: AppTextStyle.text24Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: AppSpacing.sm),
            Text(
              'You can raise a new ticket from here',
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            SupportOptionItem(
              icon: Icons.edit_outlined,
              title: 'Create Ticket',
              description: '',
              onTap: () {
                Navigator.of(context).pop();
                onCreateTicketTap();
              },
            ),
            Divider(
              color: AppColors.grey200,
              thickness: 1,
              height: 0,
            ),
            SupportOptionItem(
              icon: Icons.check,
              title: 'Track ticket status',
              description: '',
              onTap: () {
                Navigator.of(context).pop();
                onTrackTicketStatusTap();
              },
            ),
           
            // SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

