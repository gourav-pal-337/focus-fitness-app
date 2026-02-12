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
  String _countryCode = '+91';
  String _countryFlag = '🇮🇳';

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
      // Only do this if we haven't already initialized it externally?
      // Actually standard pattern is to rely on external controller if provided.
      if (widget.controller!.text.isEmpty && widget.value.isNotEmpty) {
        widget.controller!.text = widget.value;
      }
    }

    if (widget.initialCountryCode != null &&
        widget.initialCountryCode!.isNotEmpty) {
      _countryCode = widget.initialCountryCode!;
    }

    _initializePhoneField();
  }

  @override
  void didUpdateWidget(EditDetailRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if value changed
    if (oldWidget.value != widget.value) {
      if (widget.controller != null) {
        // External controller - update if different
        if (widget.controller!.text != widget.value) {
          widget.controller!.text = widget.value;
        }
      } else {
        // Internal controller - always update
        _internalController.text = widget.value;
      }
      // Re-parse phone if it's a phone field
      _initializePhoneField();
    }

    if (oldWidget.initialCountryCode != widget.initialCountryCode &&
        widget.initialCountryCode != null) {
      _countryCode = widget.initialCountryCode!;
    }
  }

  void _initializePhoneField() {
    if (widget.label.toLowerCase().contains('phone') ||
        widget.label.toLowerCase().contains('mobile') ||
        widget.label.toLowerCase().contains('contact')) {
      final text = _controller.text.trim();

      // If passing initialCountryCode, try to strip it from the text if present
      if (widget.initialCountryCode != null &&
          widget.initialCountryCode!.isNotEmpty) {
        if (text.startsWith(widget.initialCountryCode!)) {
          _controller.text = text
              .substring(widget.initialCountryCode!.length)
              .trim();
          return;
        }
      }

      if (text.startsWith('+')) {
        // Simple logic: Assume +91 or match known codes if possible
        if (text.startsWith('+91')) {
          _countryCode = '+91';
          _countryFlag = '🇮🇳';
          _controller.text = text.substring(3).trim();
        } else {
          // Fallback: try to find space
          final parts = text.split(' ');
          if (parts.length > 1 && parts[0].startsWith('+')) {
            _countryCode = parts[0];
            _controller.text = text.substring(_countryCode.length).trim();
          } else {
            // Try to guess length 3 (+XX) or 4 (+XXX)
            // Defaulting to keeping it as is might be safer if we can't determine code
            // But let's assume if we have a valid country code in state, we use that.
          }
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
        // Try parsing as ISO format first (YYYY-MM-DD)
        initialDate = DateTime.parse(_controller.text);
      } catch (e) {
        // Try parsing display format (e.g., "Jan 15, 1990")
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
        } catch (e2) {
          // Use current date if parsing fails
        }
      }
    }
    initialDate ??= DateTime.now().subtract(
      const Duration(days: 365 * 25),
    ); // Default to 25 years ago

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );

    if (picked != null) {
      // Format as ISO date (YYYY-MM-DD) for storage
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
      // Parse ISO date (YYYY-MM-DD) and format for display
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
                      if (widget.onChanged != null) {
                        widget.onChanged!('$_countryCode${_controller.text}');
                      }
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
                        if (widget.onChanged != null) {
                          widget.onChanged!('$_countryCode$value');
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
