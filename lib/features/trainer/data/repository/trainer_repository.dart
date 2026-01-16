import '../../../../features/authentication/data/exceptions/api_exception.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show Result, Success, Failure;
import '../models/book_session_request_model.dart';
import '../models/book_session_response_model.dart';
import '../models/link_trainer_request_model.dart';
import '../models/link_trainer_response_model.dart';
import '../models/linked_trainer_response_model.dart';
import '../models/trainer_referral_response_model.dart';
import '../models/trainer_profile_response_model.dart';
import '../models/unlink_trainer_response_model.dart';
import '../services/trainer_api_service.dart';

/// Repository for trainer operations
class TrainerRepository {
  final TrainerApiService _apiService = TrainerApiService();

  /// Get trainer by referral code (legacy endpoint)
  Future<Result<TrainerReferralResponseModel>> getTrainerByReferralCode(
    String referralCode,
  ) async {
    try {
      // Validate referral code length (minimum 4 characters as per API)
      if (referralCode.trim().length < 4) {
        return Failure(
          'Referral code must be at least 4 characters long.',
          code: 400,
        );
      }

      final response = await _apiService.getTrainerByReferralCode(referralCode);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }

  /// Search trainer by referral code (new endpoint with enhanced details)
  /// Requires authentication
  /// Returns list of trainers matching the search
  Future<Result<TrainerSearchResponseModel>> searchTrainerByReferralCode(
    String referralCode,
  ) async {
    try {
      // Validate referral code length (minimum 4 characters as per API)
      if (referralCode.trim().length < 4) {
        return Failure(
          'Referral code must be at least 4 characters long.',
          code: 400,
        );
      }

      final response = await _apiService.searchTrainerByReferralCode(referralCode);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode ?? 500,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }

  /// Get linked trainer for authenticated user
  Future<Result<LinkedTrainerResponseModel>> getLinkedTrainer() async {
    try {
      final response = await _apiService.getLinkedTrainer();
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode ?? 500,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }

  /// Link trainer with referral code
  Future<Result<LinkTrainerResponseModel>> linkTrainer(
    LinkTrainerRequestModel request,
  ) async {
    try {
      // Validate required fields
      if (request.referralCode.trim().length < 4) {
        return Failure(
          'Referral code must be at least 4 characters long.',
          code: 400,
        );
      }
      if (request.fullName.trim().isEmpty) {
        return Failure(
          'Full name is required.',
          code: 400,
        );
      }

      final response = await _apiService.linkTrainer(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }

  /// Get trainer profile with session plans
  Future<Result<GetTrainerProfileResponseModel>> getTrainerProfile(
    String trainerId,
  ) async {
    try {
      if (trainerId.trim().isEmpty) {
        return Failure(
          'Trainer ID is required.',
          code: 400,
        );
      }

      final response = await _apiService.getTrainerProfile(trainerId);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode ?? 500,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }

  /// Unlink trainer for authenticated user
  Future<Result<UnlinkTrainerResponseModel>> unlinkTrainer() async {
    try {
      final response = await _apiService.unlinkTrainer();
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode ?? 500,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }

  /// Book a session with a trainer
  Future<Result<BookSessionResponseModel>> bookSession(
    BookSessionRequestModel request,
  ) async {
    try {
      // Validate required fields
      if (request.trainerId.trim().isEmpty) {
        return Failure(
          'Trainer ID is required.',
          code: 400,
        );
      }
      if (request.sessionPlanId.trim().isEmpty) {
        return Failure(
          'Session plan ID is required.',
          code: 400,
        );
      }
      if (request.startTime.trim().isEmpty) {
        return Failure(
          'Start time is required.',
          code: 400,
        );
      }
      if (request.endTime.trim().isEmpty) {
        return Failure(
          'End time is required.',
          code: 400,
        );
      }

      final response = await _apiService.bookSession(request);
      return Success(response);
    } on ApiException catch (e) {
      return Failure(
        e.message,
        code: e.statusCode ?? 500,
      );
    } catch (e) {
      return Failure(
        e.toString().replaceAll('Exception: ', ''),
        code: 500,
      );
    }
  }
}

