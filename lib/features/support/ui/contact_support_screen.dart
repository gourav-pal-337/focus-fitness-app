import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';
import '../provider/contact_support_provider.dart';
import '../widgets/attach_screenshot_widget.dart';
import '../widgets/description_input_field.dart';
import '../widgets/issue_type_dropdown.dart';
import '../widgets/severity_dropdown.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactSupportProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Contact Support',
                onBack: () {
                  context.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding.left,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSpacing.lg),
                        const IssueTypeDropdown(),
                        SizedBox(height: AppSpacing.lg),
                        const SeverityDropdown(),
                        SizedBox(height: AppSpacing.lg),
                        const DescriptionInputField(),
                        SizedBox(height: AppSpacing.lg),
                        const AttachScreenshotWidget(),
                        SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Note: We usually respond within 24 hours.',
                                style: AppTextStyle.text14Regular.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Consumer<ContactSupportProvider>(
          builder: (context, provider, child) {
            if (provider.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.error!),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }

            return Container(
              padding: EdgeInsets.only(
                left: AppSpacing.screenPadding.left,
                right: AppSpacing.screenPadding.right,
                bottom: AppSpacing.lg,
                top: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: CustomButton(
                text: provider.isLoading ? 'Submitting...' : 'Submit Ticket',
                type: ButtonType.filled,
                onPressed: provider.isLoading
                    ? () {}
                    : () async {
                        final ticket = await provider.submitTicket();
                        if (ticket != null && context.mounted) {
                          context.push(TicketSuccessRoute.path, extra: ticket);
                        }
                      },
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                width: double.infinity,
                height: 54.h,
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
                borderRadius: 14.r,
              ),
            );
          },
        ),
      ),
    );
  }
}
