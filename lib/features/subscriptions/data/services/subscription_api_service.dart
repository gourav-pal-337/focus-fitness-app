import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../models/subscription_checkout_response_model.dart';
import '../models/subscription_offers_model.dart';

class SubscriptionApiService {
  final ApiHitter _apiHitter = ApiHitter();

  Future<SubscriptionOffersResponseModel> getSubscriptionOffers(
    String trainerId,
  ) async {
    final endpoint = Endpoints.getSubscriptionOffers(trainerId);
    final response = await _apiHitter.getApiResponse(endpoint);

    if (response.status) {
      if (response.response != null && response.response!.data != null) {
        return SubscriptionOffersResponseModel.fromJson(
          response.response!.data,
        );
      } else {
        throw ApiException(
          message: 'Invalid response from server',
          statusCode: 500,
        );
      }
    } else {
      throw ApiException(
        message: response.msg,
        statusCode: response.response?.statusCode,
      );
    }
  }

  Future<SubscriptionCheckoutResponseModel> checkoutSubscription(
    String trainerId,
    String planType, {
    String provider = 'stripe',
  }) async {
    final response = await _apiHitter.getPostApiResponse(
      Endpoints.subscriptionCheckout,
      data: {
        'trainerId': trainerId,
        'planType': planType,
        'provider': provider,
      },
    );

    if (response.status) {
      if (response.response != null && response.response!.data != null) {
        return SubscriptionCheckoutResponseModel.fromJson(
          response.response!.data,
        );
      } else {
        throw ApiException(
          message: 'Invalid response from server',
          statusCode: 500,
        );
      }
    } else {
      throw ApiException(
        message: response.msg,
        statusCode: response.response?.statusCode,
      );
    }
  }
}
