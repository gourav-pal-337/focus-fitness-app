class SubscriptionCheckoutResponseModel {
  final bool success;
  final String? message;
  final String? provider;
  final String? checkoutSessionId;
  final String? checkoutUrl;

  final String? clientSecret;
  final String? customerId;
  final String? ephemeralKey;

  SubscriptionCheckoutResponseModel({
    required this.success,
    this.message,
    this.provider,
    this.checkoutSessionId,
    this.checkoutUrl,
    this.clientSecret,
    this.customerId,
    this.ephemeralKey,
  });

  factory SubscriptionCheckoutResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionCheckoutResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      provider: json['provider'],
      checkoutSessionId: json['checkoutSessionId'],
      checkoutUrl: json['checkoutUrl'],
      clientSecret: json['clientSecret'],
      customerId: json['customerId'],
      ephemeralKey: json['ephemeralKey'],
    );
  }
}
