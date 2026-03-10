class InitiatePaymentRequestModel {
  final String trainerId;
  final String sessionPlanId;
  final String startTime;
  final String endTime;
  final String? timezone;
  final String? notes;
  final String provider;
  final double? serviceFee;
  final double? vatAmount;
  final double? totalAmount;
  final double? platformFeeValue;
  final String? platformFeeType;
  final double? vatTaxPercent;

  InitiatePaymentRequestModel({
    required this.trainerId,
    required this.sessionPlanId,
    required this.startTime,
    required this.endTime,
    required this.provider,
    this.timezone,
    this.notes,
    this.serviceFee,
    this.vatAmount,
    this.totalAmount,
    this.platformFeeValue,
    this.platformFeeType,
    this.vatTaxPercent,
  });

  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
      'sessionPlanId': sessionPlanId,
      'startTime': startTime,
      'endTime': endTime,
      'provider': provider,
      if (timezone != null) 'timezone': timezone,
      if (notes != null) 'notes': notes,
      if (serviceFee != null) 'serviceFee': serviceFee,
      if (vatAmount != null) 'vatAmount': vatAmount,
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (platformFeeValue != null) 'platformFeeValue': platformFeeValue,
      if (platformFeeType != null) 'platformFeeType': platformFeeType,
      if (vatTaxPercent != null) 'vatTaxPercent': vatTaxPercent,
    };
  }
}

class InitiatePaymentResponseModel {
  final bool success;
  final String? paymentId;
  final String? provider;
  final Map<String, dynamic>? bookingPreview;
  final String? clientSecret;
  final String? customerId;
  final String? ephemeralKey;
  final String? paymentIntentId;
  final String? orderId;
  final String? checkoutUrl;

  InitiatePaymentResponseModel({
    required this.success,
    this.paymentId,
    this.provider,
    this.bookingPreview,
    this.clientSecret,
    this.customerId,
    this.ephemeralKey,
    this.paymentIntentId,
    this.orderId,
    this.checkoutUrl,
  });

  factory InitiatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return InitiatePaymentResponseModel(
      success: json['success'] ?? false,
      paymentId: json['paymentId'] as String?,
      provider: json['provider'] as String?,
      bookingPreview: json['bookingPreview'] as Map<String, dynamic>?,
      clientSecret: json['clientSecret'] as String?,
      customerId: json['customerId'] as String?,
      ephemeralKey: json['ephemeralKey'] as String?,
      paymentIntentId: json['paymentIntentId'] as String?,
      orderId: json['orderId'] as String?,
      checkoutUrl: json['checkoutUrl'] as String?,
    );
  }
}

class ConfirmPaymentRequestModel {
  final String paymentId;
  final String provider;
  final String? providerPaymentId;
  final String? providerOrderId;

  ConfirmPaymentRequestModel({
    required this.paymentId,
    required this.provider,
    this.providerPaymentId,
    this.providerOrderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'provider': provider,
      if (providerPaymentId != null) 'providerPaymentId': providerPaymentId,
      if (providerOrderId != null) 'providerOrderId': providerOrderId,
    };
  }
}

class ConfirmPaymentResponseModel {
  final bool success;
  final bool alreadyConfirmed;
  final Map<String, dynamic>? booking;
  final Map<String, dynamic>? payment;

  ConfirmPaymentResponseModel({
    required this.success,
    required this.alreadyConfirmed,
    this.booking,
    this.payment,
  });

  factory ConfirmPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return ConfirmPaymentResponseModel(
      success: json['success'] ?? false,
      alreadyConfirmed: json['alreadyConfirmed'] ?? false,
      booking: json['booking'] as Map<String, dynamic>?,
      payment: json['payment'] as Map<String, dynamic>?,
    );
  }
}
