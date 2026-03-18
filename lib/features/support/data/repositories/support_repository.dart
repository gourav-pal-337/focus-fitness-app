import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/ticket_model.dart';
import '../models/faq_model.dart';
import '../services/support_api_service.dart';

class SupportRepository {
  final SupportApiService _apiService = SupportApiService();

  Future<List<FaqModel>> getFaqs() async {
    final response = await _apiService.getFaqs();
    return response.faqs ?? [];
  }

  Future<TicketModel?> createTicket({
    required String title,
    required String description,
    required String category,
    String priority = 'medium',
    File? file,
  }) async {
    final response = await _apiService.createTicket(
      title: title,
      description: description,
      category: category,
      priority: priority,
      file: file,
    );

    debugPrint('ticket 22: ${response.ticket}');
    return response.ticket;
  }

  Future<List<TicketModel>> getTickets({
    String? status,
    String? category,
  }) async {
    return _apiService.getTickets(status: status, category: category);
  }
}
