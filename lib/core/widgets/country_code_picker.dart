import 'package:canopas_country_picker/canopas_country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/theme/app_colors.dart';
import 'package:focus_fitness/features/authentication/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class MyCountryCodePicker extends StatelessWidget {
  final void Function(CountryCode? code) onCountryCodeTap;
  final String? selectedCode;
  final String? selectedFlag;
  final bool readOnly;
  const MyCountryCodePicker({
    required this.onCountryCodeTap,
    this.selectedCode,
    this.selectedFlag,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loginProv = context.watch<AuthProvider>();
    return GestureDetector(
      onTap: () async {
        if (readOnly) {
          return;
        }
        final code = await showCountryCodePickerSheet(
          context: context,
          onCountryCodeTap: (code) {
            Navigator.pop(context, code);
          },
        );
        if (code != null) {
          // loginProv.updateCountryCode(code?.dialCode, code?.flag);
          onCountryCodeTap(code);
        }
      },
      child: Container(
        // height: 40,
        // width: 80,
        // color: Colors.transparent,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          border: Border(right: BorderSide(color: AppColors.grey100)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(selectedCode ?? "+91", style: const TextStyle(fontSize: 15)),
            5.horizontalSpace,
            Text(
              selectedFlag ?? "🇮🇳",
              style: TextStyle(fontSize: 14, color: AppColors.grey400),
            ),
            5.horizontalSpace,
            const Icon(CupertinoIcons.chevron_down, size: 15),
          ],
        ),
      ),
    );
  }
}
