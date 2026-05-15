import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_hitter.dart';
import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../models/app_features_model.dart';
import '../models/system_settings_model.dart';

/// API service for system settings operations
class SystemSettingsApiService {
  final ApiHitter _apiHitter = ApiHitter();

  /// Get current fee rates
  Future<FeeSettingsModel> getFeeSettings() async {
    try {
      final response = await _apiHitter.getApiResponse(Endpoints.feeSettings);

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return FeeSettingsModel.fromJson(responseData);
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['message'] as String? ??
              responseData['error'] as String? ??
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

  /// List all system settings (Admin)
  Future<List<SystemSettingModel>> getAllSettings() async {
    try {
      final response = await _apiHitter.getApiResponse(
        Endpoints.systemSettings,
      );

      if (response.status && response.response != null) {
        final List<dynamic> responseData =
            response.response!.data as List<dynamic>;
        return responseData
            .map((e) => SystemSettingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['message'] as String? ??
              responseData['error'] as String? ??
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

  /// Update a specific setting (Admin)
  Future<bool> updateSetting(SystemSettingModel setting) async {
    try {
      final response = await _apiHitter.getPostApiResponse(
        Endpoints.systemSettings,
        data: setting.toJson(),
      );

      return response.status;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString().replaceAll('Exception: ', ''),
        statusCode: 500,
      );
    }
  }

  /// Get app features
  Future<AppFeaturesResponseModel> getAppFeatures() async {
    try {
      final response = await _apiHitter.getApiResponse(Endpoints.appFeatures);

      if (response.status && response.response != null) {
        final responseData = response.response!.data as Map<String, dynamic>;
        return AppFeaturesResponseModel.fromJson(responseData);
      } else {
        final responseData = response.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage =
              responseData['message'] as String? ??
              responseData['error'] as String? ??
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
