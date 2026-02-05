import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';
import '../provider/client_profile_provider.dart';
import 'profile_detail_card.dart';

class PersonalDetailsSection extends StatelessWidget {
  const PersonalDetailsSection({super.key});

  String? _formatDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;
    try {
      // Parse ISO date (YYYY-MM-DD) and format it
      final date = DateTime.parse(dateOfBirth);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateOfBirth;
    }
  }

  String? _formatHeight(double? height) {
    if (height == null) return null;
    return '${height.toStringAsFixed(0)}cm';
  }

  String? _formatWeight(double? weight) {
    if (weight == null) return null;
    return '${weight.toStringAsFixed(2)}kg';
  }

  String? _formatAge(int? age, String? dateOfBirth) {
    if (age == 0) {
      return null;
    }
    // Use age from profile if available, otherwise calculate from DOB
    if (age != null) {
      return '$age Years';
    }
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final today = DateTime.now();
      int calculatedAge = today.year - birthDate.year;
      // Adjust if birthday hasn't occurred this year
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        calculatedAge--;
      }
      return '$calculatedAge Years';
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.profile;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            ProfileDetailCard(
              items: [
                // ProfileDetailItem(
                //   label: 'DOB',
                //   value: _formatDateOfBirth(profile?.dateOfBirth),
                // ),
                ProfileDetailItem(
                  label: 'Age',
                  value: _formatAge(profile?.age, profile?.dateOfBirth),
                ),
                ProfileDetailItem(
                  label: 'Height',
                  value: _formatHeight(profile?.height),
                ),
                ProfileDetailItem(
                  label: 'Weight',
                  value: _formatWeight(profile?.weight),
                ),
                ProfileDetailItem(
                  label: 'Fitness Level',
                  value: profile?.fitnessLevel,
                ),
              ],
              onEdit: () {
                context.push(
                  '${EditProfileDetailsRoute.path}?title=Personal Details',
                );
              },
            ),
          ],
        );
      },
    );
  }
}
