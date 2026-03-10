import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../data/models/system_settings_model.dart';
import '../provider/system_settings_provider.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _platformFeeController = TextEditingController();
  final _vatTaxController = TextEditingController();
  String _platformFeeType = 'percentage';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SystemSettingsProvider>();
      await provider.fetchAllSettings();
      _loadSettings();
    });
  }

  void _loadSettings() {
    final provider = context.read<SystemSettingsProvider>();
    for (var setting in provider.allSettings) {
      if (setting.key == 'PLATFORM_FEE') {
        _platformFeeController.text = setting.value.toString();
        _platformFeeType = setting.type;
      } else if (setting.key == 'VAT_TAX') {
        _vatTaxController.text = setting.value.toString();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _platformFeeController.dispose();
    _vatTaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Admin Settings'),
            Expanded(
              child: Consumer<SystemSettingsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.allSettings.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Platform Fee'),
                        SizedBox(height: AppSpacing.md),
                        _buildDecimalInput(
                          controller: _platformFeeController,
                          label: 'Value',
                        ),
                        SizedBox(height: AppSpacing.md),
                        _buildTypeToggle(),
                        SizedBox(height: AppSpacing.xl),
                        _buildSectionTitle('VAT Tax'),
                        SizedBox(height: AppSpacing.md),
                        _buildDecimalInput(
                          controller: _vatTaxController,
                          label: 'Value (%)',
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Note: VAT Tax is always a percentage.',
                          style: AppTextStyle.text12Regular.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xl),
                        _buildSectionTitle('Currency'),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'USD (Display Only)',
                          style: AppTextStyle.text16SemiBold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.text18SemiBold.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildDecimalInput({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyle.text16Regular.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyle.text14Regular.copyWith(
          color: AppColors.grey400,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.grey75),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildToggleOption(
              label: 'Percentage',
              isSelected: _platformFeeType == 'percentage',
              onTap: () => setState(() => _platformFeeType = 'percentage'),
            ),
            SizedBox(width: AppSpacing.md),
            _buildToggleOption(
              label: 'Fixed Amount',
              isSelected: _platformFeeType == 'fixed',
              onTap: () => setState(() => _platformFeeType = 'fixed'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey75,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTextStyle.text14SemiBold.copyWith(
            color: isSelected ? AppColors.background : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final provider = context.watch<SystemSettingsProvider>();
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: CustomButton(
        text: 'Save Settings',
        isLoading: provider.isLoading,
        isEnabled: !provider.isLoading,
        onPressed: () async {
          final platformFee =
              double.tryParse(_platformFeeController.text) ?? 0.0;
          final vatTax = double.tryParse(_vatTaxController.text) ?? 0.0;

          // Update Platform Fee
          bool success = await provider.updateSetting(
            SystemSettingModel(
              key: 'PLATFORM_FEE',
              value: platformFee,
              type: _platformFeeType,
              description: 'Platform service fee',
            ),
          );

          if (success) {
            // Update VAT Tax
            success = await provider.updateSetting(
              SystemSettingModel(
                key: 'VAT_TAX',
                value: vatTax,
                type: 'percentage',
                description: 'VAT Tax',
              ),
            );
          }

          if (mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings updated successfully')),
            );
          } else if (mounted && provider.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(provider.error!)));
          }
        },
      ),
    );
  }
}
