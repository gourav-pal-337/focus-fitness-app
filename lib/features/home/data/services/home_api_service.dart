import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../authentication/data/exceptions/api_exception.dart';
import '../models/notification_model.dart';

class HomeApiService {
  final ApiHitter _apiHitter = ApiHitter();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiHitter.getApiResponse(Endpoints.notifications);

      if (response.status && response.response != null) {
        final data = response.response!.data;
        List<dynamic> list = [];

        if (data is List) {
          list = data;
        } else if (data is Map<String, dynamic>) {
          // Handle various wrapper keys common in APIs
          if (data.containsKey('notifications') &&
              data['notifications'] is List) {
            list = data['notifications'];
          } else if (data.containsKey('data') && data['data'] is List) {
            list = data['data'];
          } else {
            // If success is true but no list found, maybe empty?
            // Or maybe the map itself is not what we expect.
            // We'll return empty list if we can't find it to be safe, or throw?
            // Let's assume empty if not found but success is true.
          }
        }

        return list
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          message: response.msg,
          statusCode: response.response?.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
