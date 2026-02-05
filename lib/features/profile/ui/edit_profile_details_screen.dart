import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/client_profile_provider.dart';
import '../provider/edit_profile_details_provider.dart';
import '../widgets/edit_detail_row.dart';

class EditProfileDetailsScreen extends StatefulWidget {
  const EditProfileDetailsScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.section,
  });

  final String title;
  final List<EditField> fields;
  final EditProfileSection section;

  @override
  State<EditProfileDetailsScreen> createState() =>
      _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState extends State<EditProfileDetailsScreen> {
  late List<TextEditingController> _controllers;
  late List<String> _initialValues;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    _controllers = widget.fields.map((field) {
      final controller = TextEditingController(
        text: field.value.isEmpty ? '' : field.value.toString().trim(),
      );
      // Add listener to detect changes
      controller.addListener(_onFieldChanged);
      return controller;
    }).toList();

    // Store initial values for comparison
    _initialValues = widget.fields
        .map((field) => field.value.isEmpty ? '' : field.value)
        .toList();
  }

  void _onFieldChanged() {
    // Trigger rebuild to update save button state
    setState(() {});
  }

  @override
  void dispose() {
    // Remove listeners and dispose all controllers
    for (final controller in _controllers) {
      controller.removeListener(_onFieldChanged);
      controller.dispose();
    }
    super.dispose();
  }

  bool _hasChanges() {
    // Compare current values with initial values
    for (int i = 0; i < _controllers.length; i++) {
      final currentValue = _controllers[i].text;
      final initialValue = _initialValues[i];
      if (currentValue != initialValue) {
        return true;
      }
    }
    return false;
  }

  Future<void> _handleSave(BuildContext context) async {
    final provider = Provider.of<EditProfileDetailsProvider>(
      context,
      listen: false,
    );

    if (provider.isSaving) return;

    // Collect current values from all controllers
    final List<String> currentValues = _controllers
        .map((controller) => controller.text)
        .toList();

    // Update provider with current values
    for (int i = 0; i < currentValues.length; i++) {
      debugPrint("current value ${currentValues[i]}");
      provider.updateValue(i, currentValues[i]);
    }

    // Save to backend
    final success = await provider.save();
    if (success && mounted) {
      // Refresh profile data after successful save
      final profileProvider = Provider.of<ClientProfileProvider>(
        context,
        listen: false,
      );
      await profileProvider.refresh();
      if (mounted) {
        context.pop();
      }
    }
  }

  bool _isDropdownField(String label) {
    print("label name : $label");
    final lowerLabel = label.toLowerCase();

    bool value =
        lowerLabel == 'gender' ||
        lowerLabel == 'body type' ||
        lowerLabel == 'performance goal' ||
        lowerLabel == 'fitness level';
    print("value : $value");
    return value;
  }

  List<String> _getDropdownItems(String label) {
    final lowerLabel = label.toLowerCase();
    switch (lowerLabel) {
      case 'gender':
        return ['Male', 'Female', 'Others'];
      case 'body type':
        return [
          "Lean",
          "Athletic",
          "Muscular",
          "Fit",
          "Average",
          "Curvy",
          "Bulky",
        ];
      case 'performance goal':
        return [
          "Lose Weight",
          "Gain Muscle",
          "Improve Stamina",
          "Increase Strength",
          "Improve Flexibility",
          "Enhance Endurance",
          "Improve Mobility",
          "Get Fitter",
          "Maintain Fitness",
          "Improve Overall Health",
        ];
      case 'fitness level':
        return ["Beginner", "Intermediate", "Advanced", "Athlete"];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileDetailsProvider(
        fields: widget.fields,
        section: widget.section,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: widget.title,
                centerTitle: true,
                actions: [
                  Consumer2<EditProfileDetailsProvider, ClientProfileProvider>(
                    builder: (context, editProvider, clientProvider, child) {
                      final hasChanges = _hasChanges();
                      final isLoading =
                          editProvider.isSaving || clientProvider.isLoading;

                      return GestureDetector(
                        onTap: hasChanges && !isLoading
                            ? () => _handleSave(context)
                            : null,
                        child: isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.check,
                                size: 24.sp,
                                color: hasChanges
                                    ? AppColors.primary
                                    : AppColors.grey400,
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
                      Consumer<EditProfileDetailsProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: [
                              ...widget.fields.asMap().entries.map((entry) {
                                final index = entry.key;
                                final field = entry.value;
                                print(
                                  "field value: ${field.hintText} : ${field.value}",
                                );
                                final isLast =
                                    index == widget.fields.length - 1;
                                return Column(
                                  children: [
                                    EditDetailRow(
                                      label: field.label,
                                      value: field.value.toString().trim(),
                                      controller: _controllers[index],
                                      hintText: field.hintText,
                                      isDateField: field.isDateField,
                                      isDropdown: _isDropdownField(field.label),
                                      dropdownItems: _getDropdownItems(
                                        field.label,
                                      ),
                                      // No onChanged callback - values will be collected on save
                                    ),
                                    if (!isLast)
                                      Divider(
                                        color: AppColors.grey200,
                                        thickness: 1,
                                        height: 0,
                                      ),
                                  ],
                                );
                              }),
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

class EditField {
  const EditField({
    required this.label,
    required this.value,
    this.hintText,
    this.isDateField = false,
  });

  final String label;
  final String value;
  final String? hintText;
  final bool isDateField;
}
