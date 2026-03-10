import 'package:flutter_test/flutter_test.dart';
import 'package:focus_fitness/features/trainer/data/models/payment_booking_models.dart';

void main() {
  group('Payment Booking Models Parsing', () {
    test(
      'InitiatePaymentResponseModel.fromJson parses Stripe response correctly',
      () {
        final json = {
          'success': true,
          'paymentId': 'pay_123',
          'provider': 'stripe',
          'clientSecret': 'secret_456',
          'customerId': 'cus_789',
          'ephemeralKey': 'ek_012',
          'paymentIntentId': 'pi_345',
        };

        final model = InitiatePaymentResponseModel.fromJson(json);

        expect(model.success, isTrue);
        expect(model.paymentId, 'pay_123');
        expect(model.provider, 'stripe');
        expect(model.clientSecret, 'secret_456');
        expect(model.customerId, 'cus_789');
        expect(model.ephemeralKey, 'ek_012');
        expect(model.paymentIntentId, 'pi_345');
        expect(model.checkoutUrl, isNull);
      },
    );

    test(
      'InitiatePaymentResponseModel.fromJson parses PayPal response correctly',
      () {
        final json = {
          'success': true,
          'paymentId': 'pay_123',
          'provider': 'paypal',
          'orderId': 'order_789',
          'checkoutUrl': 'https://paypal.com/checkout/123',
        };

        final model = InitiatePaymentResponseModel.fromJson(json);

        expect(model.success, isTrue);
        expect(model.paymentId, 'pay_123');
        expect(model.provider, 'paypal');
        expect(model.orderId, 'order_789');
        expect(model.checkoutUrl, 'https://paypal.com/checkout/123');
        expect(model.clientSecret, isNull);
      },
    );

    test('ConfirmPaymentResponseModel.fromJson parses successfully', () {
      final json = {
        'success': true,
        'alreadyConfirmed': false,
        'booking': {'id': 'b_1'},
        'payment': {'status': 'succeeded'},
      };

      final model = ConfirmPaymentResponseModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.alreadyConfirmed, isFalse);
      expect(model.booking?['id'], 'b_1');
      expect(model.payment?['status'], 'succeeded');
    });
  });
}
