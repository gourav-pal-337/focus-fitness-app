import 'package:canopas_country_picker/canopas_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/theme/app_radius.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/country_code_picker.dart';

class EditDetailRow extends StatefulWidget {
  const EditDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.controller,
    this.hintText,
    this.onChanged,
    this.isDateField = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.initialCountryCode,
    this.onCountryCodeChanged,
  });

  final String label;
  final String value;
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool isDateField;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? initialCountryCode;
  final ValueChanged<String>? onCountryCodeChanged;

  @override
  State<EditDetailRow> createState() => _EditDetailRowState();
}

class _EditDetailRowState extends State<EditDetailRow> {
  late TextEditingController _internalController;
  bool _isInternalController = false;
  String _countryCode = '+44';
  String _countryFlag = '🇬🇧';

  TextEditingController get _controller {
    return widget.controller ?? _internalController;
  }

  @override
  void initState() {
    super.initState();
    // Create internal controller if not provided
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.value.isEmpty ? '' : widget.value,
      );
      _isInternalController = true;
    } else {
      // Initialize provided controller with initial value if empty
      if (widget.controller!.text.isEmpty && widget.value.isNotEmpty) {
        widget.controller!.text = widget.value;
      }
    }

    if (widget.initialCountryCode != null &&
        widget.initialCountryCode!.isNotEmpty) {
      debugPrint('initialCountryCode: ${widget.initialCountryCode}');
      _countryCode = widget.initialCountryCode!;
      _countryFlag = _getFlagForCode(_countryCode);
    }

    _initializePhoneField();
  }

  @override
  void didUpdateWidget(EditDetailRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if value changed - but be careful not to overwrite user input
    // Only update if the PROP value changed significantly (e.g. parent forced update)
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      // _controller.text = widget.value; // Removing this auto-update for now as it causes jumps if logic differs
    }

    if (oldWidget.initialCountryCode != widget.initialCountryCode &&
        widget.initialCountryCode != null) {
      _countryCode = widget.initialCountryCode!;
      _countryFlag = _getFlagForCode(_countryCode);
    }
  }

  String _getFlagForCode(String code) {
    debugPrint('code: $code');
    CountryCode countryCode = CountryCode.getCountryCodeByDialCode(
      dialCode: code,
    );
    debugPrint('countryCode: ${countryCode.flag}');
    return countryCode.flag;
  }

  void _initializePhoneField() {
    if (widget.label.toLowerCase().contains('phone') ||
        widget.label.toLowerCase().contains('mobile') ||
        widget.label.toLowerCase().contains('contact')) {
      // The parent EditProfileDetailsScreen now handles stripping the code from the initial value passed to controller.
      // So _controller.text should ALREADY be stripped of the code if the parent did its job.

      // However, we still need to set our local _countryCode if it wasn't passed via initialCountryCode prop
      // but might be hiding in the text (fallback).

      if (widget.initialCountryCode == null ||
          widget.initialCountryCode!.isEmpty) {
        final text = _controller.text.trim();
        if (text.startsWith('+')) {
          if (text.startsWith('+91')) {
            _countryCode = '+91';
            _countryFlag = '🇮🇳';
            // If text still has it, strip it (though parent should have done it)
            if (_controller.text.startsWith('+91')) {
              _controller.text = text.substring(3).trim();
            }
          } else {
            // checking other codes...
            final parts = text.split(' ');
            if (parts.length > 1 && parts[0].startsWith('+')) {
              _countryCode = parts[0];
              _countryFlag = _getFlagForCode(_countryCode);
              _controller.text = text.substring(_countryCode.length).trim();
            }
          }
        }

        // Sync back the detected or default country code to parent
        if (widget.onCountryCodeChanged != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onCountryCodeChanged!(_countryCode);
            }
          });
        }
      }
    }
  }

  @override
  void dispose() {
    // Only dispose if we created it internally
    if (_isInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? initialDate;
    if (_controller.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_controller.text);
      } catch (e) {
        try {
          final months = {
            'Jan': 1,
            'Feb': 2,
            'Mar': 3,
            'Apr': 4,
            'May': 5,
            'Jun': 6,
            'Jul': 7,
            'Aug': 8,
            'Sep': 9,
            'Oct': 10,
            'Nov': 11,
            'Dec': 12,
          };
          final parts = _controller.text.split(' ');
          if (parts.length == 3 && months.containsKey(parts[0])) {
            final month = months[parts[0]]!;
            final day = int.parse(parts[1].replaceAll(',', ''));
            final year = int.parse(parts[2]);
            initialDate = DateTime(year, month, day);
          }
        } catch (e2) {}
      }
    }
    initialDate ??= DateTime.now().subtract(const Duration(days: 365 * 25));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );

    if (picked != null) {
      final formattedDate =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _controller.text = formattedDate;
      if (widget.onChanged != null) {
        widget.onChanged!(formattedDate);
      }
    }
  }

  String _formatDateForDisplay(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
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
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPhone =
        widget.label.toLowerCase().contains('phone') ||
        widget.label.toLowerCase().contains('mobile') ||
        widget.label.toLowerCase().contains('contact');

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: AppSpacing.screenPadding.left,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ),
          if (isPhone) ...[
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: SizedBox(
                child: MyCountryCodePicker(
                  selectedCode: _countryCode,
                  selectedFlag: _countryFlag,
                  onCountryCodeTap: (code) {
                    if (code != null) {
                      setState(() {
                        _countryCode = code.dialCode;
                        _countryFlag = code.flag;
                      });
                      if (widget.onCountryCodeChanged != null) {
                        widget.onCountryCodeChanged!(_countryCode);
                      }
                      // We do NOT call widget.onChanged here anymore because
                      // the text field content hasn't changed.
                      // The parent tracks country code separately via onCountryCodeChanged.
                    }
                  },
                ),
              ),
            ),
          ],

          Expanded(
            child: widget.isDateField
                ? GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Text(
                      _controller.text.isEmpty
                          ? (widget.hintText ?? 'Select date')
                          : _formatDateForDisplay(_controller.text),
                      textAlign: TextAlign.right,
                      style: AppTextStyle.text16Regular.copyWith(
                        color: _controller.text.isEmpty
                            ? AppColors.grey400
                            : AppColors.textPrimary,
                        fontStyle: _controller.text.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  )
                : widget.isDropdown
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      borderRadius: AppRadius.medium,
                      isDense: true,
                      isExpanded: true,
                      value:
                          widget.dropdownItems?.contains(_controller.text) ==
                              true
                          ? _controller.text
                          : null,
                      hint: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.hintText ?? 'Select option',
                          style: AppTextStyle.text16Regular.copyWith(
                            color: AppColors.grey400,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      icon: const SizedBox.shrink(),
                      alignment: Alignment.centerRight,
                      selectedItemBuilder: (BuildContext context) {
                        return widget.dropdownItems!.map((String value) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              value,
                              style: AppTextStyle.text16Regular.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        }).toList();
                      },
                      items: widget.dropdownItems?.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: AppTextStyle.text16Regular.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _controller.text = newValue;
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged!(newValue);
                          }
                        }
                      },
                    ),
                  )
                : TextField(
                    controller: _controller,
                    onChanged: (value) {
                      debugPrint("value : $value");
                      if (isPhone) {
                        // For phone, we just pass the RAW phone number.
                        // The parent converts it to 'code+phone' on SAVE.
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                        return;
                      }
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    },
                    textAlign: TextAlign.right,
                    keyboardType: isPhone
                        ? TextInputType.phone
                        : TextInputType.text,
                    inputFormatters: isPhone
                        ? [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ]
                        : null,
                    // ... decoration ...
                    style: AppTextStyle.text16Regular.copyWith(
                      color: _controller.text.isEmpty
                          ? AppColors.grey400
                          : AppColors.textPrimary,
                      fontStyle: _controller.text.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: widget.hintText,
                      hintStyle: AppTextStyle.text16Regular.copyWith(
                        color: AppColors.grey400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
