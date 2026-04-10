import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../provider/system_settings_provider.dart';

class PaymentBreakdownWidget extends StatefulWidget {
  final double sessionPrice;
  final String? currency;

  const PaymentBreakdownWidget({
    super.key,
    required this.sessionPrice,
    this.currency,
  });

  @override
  State<PaymentBreakdownWidget> createState() => _PaymentBreakdownWidgetState();
}

class _PaymentBreakdownWidgetState extends State<PaymentBreakdownWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SystemSettingsProvider>().fetchFeeSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemSettingsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.feeSettings == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = provider.feeSettings;
        if (settings == null) {
          return const SizedBox.shrink();
        }

        // 1. Calculate Service Fee
        final serviceFeeValue = settings.platformFeeType == 'fixed'
            ? settings.platformFee
            : (widget.sessionPrice * (settings.platformFee / 100));

        final displayPlatformFeeValue = CurrencyFormatter.format(
          serviceFeeValue,
          settings.platformFeeCurrency,
        );
        final displayPlatformFeeRate = settings.platformFeeType == 'fixed'
            ? ''
            : ' (${settings.platformFee.toStringAsFixed(0)}%)';

        // 2. Calculate VAT (always percentage)
        final vatValue = widget.sessionPrice * (settings.vatTaxPercent / 100);
        final displayVatValue = CurrencyFormatter.format(
          vatValue,
          settings.platformFeeCurrency,
        );

        // 3. Calculate Total
        final totalCharged = provider.calculateTotalAmount(widget.sessionPrice);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Info',
              style: AppTextStyle.text20SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            _PaymentRow(
              label: 'Session Price',
              value: CurrencyFormatter.format(
                widget.sessionPrice,
                settings.platformFeeCurrency,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            _PaymentRow(
              label: 'Service Fee$displayPlatformFeeRate',
              value: displayPlatformFeeValue,
              isSubText: true,
            ),
            SizedBox(height: AppSpacing.sm),
            _PaymentRow(
              label: 'Tax (VAT ${settings.vatTaxPercent.toStringAsFixed(0)}%)',
              value: displayVatValue,
              isSubText: true,
            ),
            SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.grey75),
            SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Charged',
                  style: AppTextStyle.text20SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(
                    totalCharged,
                    settings.platformFeeCurrency,
                  ),
                  style: AppTextStyle.text20SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.label,
    required this.value,
    this.isSubText = false,
  });

  final String label;
  final String value;
  final bool isSubText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.text16Regular.copyWith(
            color: isSubText ? AppColors.grey400 : AppColors.textPrimary,
            fontSize: isSubText ? 14.sp : 16.sp,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.text16Regular.copyWith(
            color: isSubText ? AppColors.grey400 : AppColors.textPrimary,
            fontSize: isSubText ? 14.sp : 16.sp,
          ),
        ),
      ],
    );
  }
}
