import 'package:flutter/foundation.dart';

import '../data/models/subscription_checkout_response_model.dart';
import '../data/models/subscription_offers_model.dart';
import '../data/repository/subscription_repository.dart';
import '../../authentication/data/repository/auth_repository.dart'
    show ResultExtension;

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepository _repository = SubscriptionRepository();

  SubscriptionOfferModel? _selectedPlan;
  SubscriptionOfferModel? get selectedPlan => _selectedPlan;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<SubscriptionOfferModel> _offers = [];
  List<SubscriptionOfferModel> get offers => _offers;

  SubscriptionTrainerModel? _trainer;
  SubscriptionTrainerModel? get trainer => _trainer;

  List<String> _paymentProviders = [];
  List<String> get paymentProviders => _paymentProviders;

  Future<void> fetchOffers(String trainerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getSubscriptionOffers(trainerId);

      await result.when(
        success: (response) async {
          _offers = response.offers ?? [];
          _trainer = response.trainer;
          _paymentProviders = response.paymentProviders ?? [];

          if (_offers.isNotEmpty) {
            // Default select the first plan, or sort them somehow
            _selectedPlan = _offers.first;
          }

          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        failure: (message, code) {
          _offers = [];
          _trainer = null;
          _paymentProviders = [];
          _error = message;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPlan(SubscriptionOfferModel plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  bool _isCheckingOut = false;
  bool get isCheckingOut => _isCheckingOut;

  Future<SubscriptionCheckoutResponseModel?> checkout(String trainerId) async {
    if (_selectedPlan == null) return null;

    _isCheckingOut = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.checkoutSubscription(
        trainerId,
        _selectedPlan!.planType,
      );

      SubscriptionCheckoutResponseModel? responseData;

      await result.when(
        success: (response) async {
          responseData = response;
          _isCheckingOut = false;
          notifyListeners();
        },
        failure: (message, code) {
          _error = message;
          _isCheckingOut = false;
          notifyListeners();
        },
      );

      return responseData;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isCheckingOut = false;
      notifyListeners();
      return null;
    }
  }
}
