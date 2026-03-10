/// Response model for booking payment details
class BookingPaymentResponseModel {
  BookingPaymentResponseModel({required this.success, this.payment});

  final bool success;
  final BookingPayment? payment;

  factory BookingPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingPaymentResponseModel(
      success: json['success'] as bool? ?? false,
      payment: json['payment'] != null
          ? BookingPayment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Booking payment model
class BookingPayment {
  BookingPayment({
    required this.id,
    required this.trainerId,
    required this.bookingId,
    required this.sessionPlanId,
    required this.clientName,
    required this.amount,
    required this.currency,
    required this.platformFee,
    required this.vatAmount,
    required this.applicationFeeAmount,
    required this.paymentType,
    required this.status,
    required this.provider,
    required this.providerStatus,
    required this.providerPaymentId,
    required this.stripePaymentIntentId,
    required this.stripeChargeId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.totalAmount,
    this.providerCustomerId,
    this.payoutStatus,
  });

  final String id;
  final String trainerId;
  final String bookingId;
  final String sessionPlanId;
  final String clientName;
  final double amount;
  final String currency;
  final double platformFee;
  final double vatAmount;
  final double applicationFeeAmount;
  final String paymentType;
  final String status;
  final String provider;
  final String providerStatus;
  final String providerPaymentId;
  final String stripePaymentIntentId;
  final String stripeChargeId;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String bookingStatus;
  final String paymentStatus;
  final double totalAmount;
  final String? providerCustomerId;
  final String? payoutStatus;

  factory BookingPayment.fromJson(Map<String, dynamic> json) {
    return BookingPayment(
      id: json['_id'] as String? ?? '',
      trainerId: json['trainerId'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
      sessionPlanId: json['sessionPlanId'] as String? ?? '',
      clientName: json['clientName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? '',
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      vatAmount: (json['vatAmount'] as num?)?.toDouble() ?? 0.0,
      applicationFeeAmount:
          (json['applicationFeeAmount'] as num?)?.toDouble() ?? 0.0,
      paymentType: json['paymentType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      providerStatus: json['providerStatus'] as String? ?? '',
      providerPaymentId: json['providerPaymentId'] as String? ?? '',
      stripePaymentIntentId: json['stripePaymentIntentId'] as String? ?? '',
      stripeChargeId: json['stripeChargeId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      bookingStatus: json['bookingStatus'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      providerCustomerId: json['providerCustomerId'] as String?,
      payoutStatus: json['payoutStatus'] as String?,
    );
  }
}
