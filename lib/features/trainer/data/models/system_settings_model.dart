/// Model for fee settings
class FeeSettingsModel {
  final double platformFee;
  final String platformFeeType;
  final String platformFeeCurrency;
  final double vatTaxPercent;
  final String vatTaxType;

  FeeSettingsModel({
    required this.platformFee,
    required this.platformFeeType,
    required this.platformFeeCurrency,
    required this.vatTaxPercent,
    required this.vatTaxType,
  });

  factory FeeSettingsModel.fromJson(Map<String, dynamic> json) {
    return FeeSettingsModel(
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      platformFeeType: json['platformFeeType'] as String? ?? 'percentage',
      platformFeeCurrency: json['platformFeeCurrency'] as String? ?? 'USD',
      vatTaxPercent: (json['vatTaxPercent'] as num?)?.toDouble() ?? 0.0,
      vatTaxType: json['vatTaxType'] as String? ?? 'percentage',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platformFee': platformFee,
      'platformFeeType': platformFeeType,
      'platformFeeCurrency': platformFeeCurrency,
      'vatTaxPercent': vatTaxPercent,
      'vatTaxType': vatTaxType,
    };
  }
}

/// Model for a general system setting
class SystemSettingModel {
  final String key;
  final dynamic value;
  final String type;
  final String description;

  SystemSettingModel({
    required this.key,
    required this.value,
    required this.type,
    required this.description,
  });

  factory SystemSettingModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingModel(
      key: json['key'] as String? ?? '',
      value: json['value'],
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'type': type,
      'description': description,
    };
  }
}
