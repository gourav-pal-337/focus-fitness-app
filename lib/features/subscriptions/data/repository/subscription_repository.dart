import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show Result, Success, Failure;
import '../models/subscription_checkout_response_model.dart';
import '../models/subscription_offers_model.dart';
import '../services/subscription_api_service.dart';

class SubscriptionRepository {
  final SubscriptionApiService _apiService = SubscriptionApiService();

  Future<Result<SubscriptionOffersResponseModel>> getSubscriptionOffers(
    String trainerId,
  ) async {
    try {
      if (trainerId.trim().isEmpty) {
        return Failure('Trainer ID is required.', code: 400);
      }

      final response = await _apiService.getSubscriptionOffers(trainerId);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<SubscriptionCheckoutResponseModel>> checkoutSubscription(
    String trainerId,
    String planType, {
    String provider = 'stripe',
  }) async {
    try {
      if (trainerId.trim().isEmpty) {
        return Failure('Trainer ID is required.', code: 400);
      }
      if (planType.trim().isEmpty) {
        return Failure('Plan Type is required.', code: 400);
      }

      final response = await _apiService.checkoutSubscription(
        trainerId,
        planType,
        provider: provider,
      );
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
}
