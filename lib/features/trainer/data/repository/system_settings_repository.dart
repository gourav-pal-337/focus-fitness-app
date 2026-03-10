import '../../../authentication/data/repository/auth_repository.dart';
import '../../../authentication/data/exceptions/api_exception.dart';
import '../models/system_settings_model.dart';
import '../services/system_settings_api_service.dart';

class SystemSettingsRepository {
  final SystemSettingsApiService _apiService = SystemSettingsApiService();

  Future<Result<FeeSettingsModel>> getFeeSettings() async {
    try {
      final response = await _apiService.getFeeSettings();
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<List<SystemSettingModel>>> getAllSettings() async {
    try {
      final response = await _apiService.getAllSettings();
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<bool>> updateSetting(SystemSettingModel setting) async {
    try {
      final response = await _apiService.updateSetting(setting);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
}
