import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../models/faq_model.dart';
import '../models/ticket_model.dart';

class SupportApiService {
  final ApiHitter _apiHitter = ApiHitter();

  Future<FaqsResponse> getFaqs() async {
    try {
      final response = await _apiHitter.getApiResponse(Endpoints.getFaqs);

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return FaqsResponse.fromJson(responseData);
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
          );
        }

        throw ApiException(
          message: response.msg,
          statusCode: response.response?.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString().replaceAll('Exception: ', ''),
        statusCode: 500,
      );
    }
  }

  Future<CreateTicketResponse> createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
    File? file,
  }) async {
    try {
      final map = {
        'title': title,
        'description': description,
        'category': category.toLowerCase(),
        'priority': priority.toLowerCase(),
      };

      FormData formData;
      if (file != null) {
        formData = FormData.fromMap({
          ...map,
          'attachments': await MultipartFile.fromFile(file.path),
        });
      } else {
        formData = FormData.fromMap(map);
      }

      final response = await _apiHitter.getPostApiResponse(
        Endpoints.createTicket,
        data: formData,
      );

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return CreateTicketResponse.fromJson(responseData);
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['error'] as String? ??
              responseData['message'] as String? ??
              response.msg;

          throw ApiException(
            message: errorMessage,
            statusCode: response.response?.statusCode,
          );
        }

        throw ApiException(
          message: response.msg,
          statusCode: response.response?.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString().replaceAll('Exception: ', ''),
        statusCode: 500,
      );
    }
  }
}
