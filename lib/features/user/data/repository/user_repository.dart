import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../../../../features/authentication/data/models/get_user_response_model.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show Result, Success, Failure;
import '../services/user_api_service.dart';

/// Repository for user operations
class UserRepository {
  final UserApiService _apiService = UserApiService();

  /// Get current user details
  Future<Result<GetUserResponseModel>> getUserDetails() async {
    try {
      final response = await _apiService.getUserDetails();
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<bool>> updateFcmToken({
    required String token,
    required String platform,
  }) async {
    try {
      final success = await _apiService.updateFcmToken(
        token: token,
        platform: platform,
      );
      return Success(success);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
}
