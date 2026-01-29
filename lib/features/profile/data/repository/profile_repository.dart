import 'package:flutter/material.dart';

import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show Result, Success, Failure;
import '../models/get_client_profile_response_model.dart';
import '../models/update_client_profile_request_model.dart';
import '../models/update_client_profile_response_model.dart';
import '../services/profile_api_service.dart';

/// Repository for client profile operations
class ProfileRepository {
  final ProfileApiService _apiService = ProfileApiService();

  Future<Result<GetClientProfileResponseModel>> getClientProfile() async {
    try {
      final response = await _apiService.getClientProfile();
      return Success(response);
    } on ApiException catch (e) {
      debugPrint("profile error ${e.message}");
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }

  Future<Result<UpdateClientProfileResponseModel>> updateClientProfile(
    UpdateClientProfileRequestModel request,
  ) async {
    try {
      final response = await _apiService.updateClientProfile(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(e.message, code: e.statusCode ?? 500);
    } catch (e) {
      return Failure(e.toString().replaceAll('Exception: ', ''), code: 500);
    }
  }
}
