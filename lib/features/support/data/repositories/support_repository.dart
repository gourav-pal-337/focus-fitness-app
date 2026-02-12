import 'dart:io';
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
    return response.ticket;
  }
}
