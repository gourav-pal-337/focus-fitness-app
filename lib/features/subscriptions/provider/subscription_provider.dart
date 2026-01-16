import 'package:flutter/foundation.dart';

enum SubscriptionPlan {
  weekly,
  monthly,
  annual,
}

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.monthly;

  SubscriptionPlan get selectedPlan => _selectedPlan;

  void selectPlan(SubscriptionPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }
}

