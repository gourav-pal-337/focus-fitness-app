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
import '../widgets/subject_input_field.dart';

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
                        const SubjectInputField(),
                        SizedBox(height: AppSpacing.lg),
                        const DescriptionInputField(),
                        SizedBox(height: AppSpacing.lg),
                        const AttachScreenshotWidget(),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          'Note: We usually respond within 24 hours.',
                          style: AppTextStyle.text14Regular.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xl),
                        Consumer<ContactSupportProvider>(
                          builder: (context, provider, child) {
                            return CustomButton(
                              text: 'Submit Ticket',
                              type: ButtonType.filled,
                              onPressed: () {
                                provider.submitTicket();
                                // Navigate to success screen
                                context.push(TicketSuccessRoute.path);
                              },
                              textStyle: AppTextStyle.text16SemiBold.copyWith(
                                color: AppColors.background,
                              ),
                              width: double.infinity,
                              backgroundColor: AppColors.primary,
                              textColor: AppColors.background,
                              borderRadius: 12.r,
                            );
                          },
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
      ),
    );
  }
}

