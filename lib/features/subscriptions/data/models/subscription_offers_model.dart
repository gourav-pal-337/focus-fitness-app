class SubscriptionOffersResponseModel {
  final bool success;
  final SubscriptionTrainerModel? trainer;
  final List<SubscriptionOfferModel>? offers;
  final List<String>? paymentProviders;

  SubscriptionOffersResponseModel({
    required this.success,
    this.trainer,
    this.offers,
    this.paymentProviders,
  });

  factory SubscriptionOffersResponseModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionOffersResponseModel(
      success: json['success'] ?? false,
      trainer: json['trainer'] != null
          ? SubscriptionTrainerModel.fromJson(json['trainer'])
          : null,
      offers: json['offers'] != null
          ? (json['offers'] as List)
                .map((e) => SubscriptionOfferModel.fromJson(e))
                .toList()
          : null,
      paymentProviders: json['paymentProviders'] != null
          ? List<String>.from(json['paymentProviders'])
          : null,
    );
  }
}

class SubscriptionTrainerModel {
  final String id;
  final String? userId;
  final String name;
  final String? currency;

  SubscriptionTrainerModel({
    required this.id,
    this.userId,
    required this.name,
    this.currency,
  });

  factory SubscriptionTrainerModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionTrainerModel(
      id: json['id'] ?? '',
      userId: json['userId'],
      name: json['name'] ?? '',
      currency: json['currency'],
    );
  }
}

class SubscriptionOfferModel {
  final String planType;
  final String title;
  final String interval;
  final num amount;
  final String currency;
  final num sessionsPerMonth;
  final num effectivePerSession;

  SubscriptionOfferModel({
    required this.planType,
    required this.title,
    required this.interval,
    required this.amount,
    required this.currency,
    required this.sessionsPerMonth,
    required this.effectivePerSession,
  });

  factory SubscriptionOfferModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionOfferModel(
      planType: json['planType'] ?? '',
      title: json['title'] ?? '',
      interval: json['interval'] ?? '',
      amount: json['amount'] ?? 0.0,
      currency: json['currency'] ?? 'USD',
      sessionsPerMonth: json['sessionsPerMonth'] ?? 0,
      effectivePerSession: json['effectivePerSession'] ?? 0.0,
    );
  }
}
