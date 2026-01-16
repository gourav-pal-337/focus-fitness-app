import 'package:flutter/foundation.dart';

import '../data/models/link_trainer_response_model.dart';
import '../data/models/trainer_referral_response_model.dart';
import '../data/models/unlink_trainer_response_model.dart';
import '../data/repository/trainer_repository.dart';
import '../../../../features/authentication/data/repository/auth_repository.dart'
    show ResultExtension;

/// Provider to manage trainer-related state (linked trainer, delink form, etc.)
class LinkedTrainerProvider extends ChangeNotifier {
  final TrainerRepository _repository = TrainerRepository();

  // Linked trainer state
  bool _isLoading = false;
  bool _isLinked = false;
  TrainerInfo? _trainer;
  ClientProfile? _profile;
  String? _error;

  // Delink trainer form state
  String _delinkReason = '';
  String _delinkComments = '';

  // Linked trainer getters
  bool get isLoading => _isLoading;
  bool get isLinked => _isLinked;
  TrainerInfo? get trainer => _trainer;
  ClientProfile? get profile => _profile;
  String? get error => _error;

  // Delink form getters
  String get delinkReason => _delinkReason;
  String get delinkComments => _delinkComments;
  bool get canDelink => _delinkReason.isNotEmpty;

  /// Fetch linked trainer information
  Future<void> fetchLinkedTrainer() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _repository.getLinkedTrainer();

      await result.when(
        success: (response) async {
          _isLinked = response.linked;
          _trainer = response.trainer;
          _profile = response.profile;
          _error = null;
          _isLoading = false;
          notifyListeners();
        },
        failure: (message, code) {
          _isLinked = false;
          _trainer = null;
          _profile = null;
          _error = message;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _isLinked = false;
      _trainer = null;
      _profile = null;
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear linked trainer data
  void clear() {
    _isLinked = false;
    _trainer = null;
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Refresh linked trainer data
  Future<void> refresh() async {
    await fetchLinkedTrainer();
  }

  /// Update delink reason
  void updateDelinkReason(String reason) {
    _delinkReason = reason;
    notifyListeners();
  }

  /// Update delink comments
  void updateDelinkComments(String comments) {
    _delinkComments = comments;
    notifyListeners();
  }

  /// Reset delink form
  void resetDelinkForm() {
    _delinkReason = '';
    _delinkComments = '';
    notifyListeners();
  }

  /// Clear all trainer data (used after successful delink)
  void clearAll() {
    _isLinked = false;
    _trainer = null;
    _profile = null;
    _error = null;
    _isLoading = false;
    _delinkReason = '';
    _delinkComments = '';
    notifyListeners();
  }

  /// Unlink trainer using API
  Future<bool> unlinkTrainer() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.unlinkTrainer();

      bool success = false;
      await result.when(
        success: (UnlinkTrainerResponseModel response) async {
          // Even if unlinked is false, API call itself succeeded
          success = response.success;
          // Clear local trainer data
          clearAll();
        },
        failure: (message, code) {
          _error = message;
          success = false;
        },
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}

