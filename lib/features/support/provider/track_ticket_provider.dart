import 'package:flutter/material.dart';
import '../data/models/ticket_model.dart';
import '../data/repositories/support_repository.dart';

class TrackTicketProvider extends ChangeNotifier {
  final SupportRepository _repository = SupportRepository();
  bool _isLoading = false;
  List<TicketModel> _tickets = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<TicketModel> get tickets => _tickets;
  String? get error => _error;

  Future<void> fetchTickets({String? status, String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tickets = await _repository.getTickets(
        status: status,
        category: category,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
