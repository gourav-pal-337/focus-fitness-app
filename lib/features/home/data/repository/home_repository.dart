import '../models/notification_model.dart';
import '../services/home_api_service.dart';

class HomeRepository {
  final HomeApiService _apiService;

  HomeRepository({HomeApiService? apiService})
    : _apiService = apiService ?? HomeApiService();

  Future<List<NotificationModel>> getNotifications() async {
    return await _apiService.getNotifications();
  }
}
