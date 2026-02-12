import 'package:flutter/material.dart';
import '../data/models/faq_model.dart';
import '../data/repositories/support_repository.dart';

class SupportProvider extends ChangeNotifier {
  final SupportRepository _repository = SupportRepository();
  bool _isLoading = false;
  List<FaqModel> _faqs = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<FaqModel> get faqs => _faqs;
  String? get error => _error;

  Future<void> fetchFaqs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _faqs = await _repository.getFaqs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
