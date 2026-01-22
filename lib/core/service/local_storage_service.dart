import 'dart:convert';
import 'dart:developer';

import 'package:encrypt_shared_preferences/provider.dart';

import '../../features/authentication/data/models/register_response_model.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  // Encryption key must be exactly 16 characters for AES encryption
  static const String _encryptionKey = 'focus_fitness_ap'; // 16 characters

  // Key constants
  static const String _tokenKey = 'token';
  static const String _nameKey = 'name';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _userId = 'userId';
  static const String _onboarding = 'onboarding';
  static const String _userName = 'username';
  static const String _language = 'language';
  static const String _sessionSwipeInfoShown = 'sessionSwipeInfoShown';
  static const String _sessionOngoing = 'sessionOngoing';
  static const String _recentLocationsKey = 'recentLocations';
  static const String _recentHotelSearchesKey = 'recentHotelSearches';
  static const String _twoFactorAuthEnabled = 'twoFactorAuthEnabled';
  static const String _userKey = 'user_data';

  final EncryptedSharedPreferences _prefs;

  /// Private constructor
  LocalStorageService._internal(this._prefs);

  /// Factory constructor that returns singleton instance
  /// Initializes EncryptedSharedPreferences on first instance creation
  factory LocalStorageService() {
    if (_instance == null) {
      EncryptedSharedPreferences.initialize(_encryptionKey);
      final prefs = EncryptedSharedPreferences.getInstance();
      _instance = LocalStorageService._internal(prefs);
    }
    return _instance!;
  }

  /// Initialize encrypted shared preferences (call this before first use if async initialization needed)
  static Future<void> init() async {
    if (_instance == null) {
      await EncryptedSharedPreferences.initialize(_encryptionKey);
      final prefs = EncryptedSharedPreferences.getInstance();
      _instance = LocalStorageService._internal(prefs);
    }
  }

  /// Get singleton instance (initializes if needed)
  static EncryptedSharedPreferences get _prefsInstance {
    if (_instance == null) {
      EncryptedSharedPreferences.initialize(_encryptionKey);
      final prefs = EncryptedSharedPreferences.getInstance();
      _instance = LocalStorageService._internal(prefs);
    }
    return _instance!._prefs;
  }

  static Future<String?> getToken() async {
    return await _prefsInstance.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    await _prefsInstance.setString(_tokenKey, token);
  }

  static Future<String?> getLanguage() async {
    return await _prefsInstance.getString(_language);
  }

  static Future<void> setLanguage(String language) async {
    await _prefsInstance.setString(_language, language);
  }

  static Future<String?> getUsername() async {
    return await _prefsInstance.getString(_userName);
  }

  static Future<void> setUsername(String name) async {
    await _prefsInstance.setString(_nameKey, name);
  }

  static Future<String> getName() async {
    return await _prefsInstance.getString(_nameKey) ?? '';
  }

  static Future<String> getRefreshToken() async {
    return await _prefsInstance.getString(_refreshTokenKey) ?? '';
  }

  static Future<bool> setRefreshToken(String refreshToken) async {
    try {
      await _prefsInstance.setString(_refreshTokenKey, refreshToken);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<String?> getUserId() async {
    return await _prefsInstance.getString(_userId);
  }

  static Future<bool> setUserId(String userId) async {
    try {
      await _prefsInstance.setString(_userId, userId);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool?> getOnboarding() async {
    final value = await _prefsInstance.getString(_onboarding);
    if (value == null) return null;
    return value == 'true';
  }

  static Future<bool> setOnboarding(bool onboardStatus) async {
    try {
      await _prefsInstance.setString(_onboarding, onboardStatus.toString());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool?> getSessionSwipeInfoShown() async {
    final value = await _prefsInstance.getString(_sessionSwipeInfoShown);
    if (value == null) return null;
    return value == 'true';
  }

  static Future<bool> setSessionSwipeInfoShown(bool swipeShown) async {
    try {
      await _prefsInstance.setString(
        _sessionSwipeInfoShown,
        swipeShown.toString(),
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<String?> getSessionOngoing() async {
    return await _prefsInstance.getString(_sessionOngoing);
  }

  static Future<void> setSessionOngoing(String? sessionOngoing) async {
    await _prefsInstance.setString(_sessionOngoing, sessionOngoing ?? '');
  }

  static Future<void> setAppleEmail(String appleId, String email) async {
    await _prefsInstance.setString('apple_email_$appleId', email);
  }

  static Future<String?> getAppleEmail(String appleId) async {
    return await _prefsInstance.getString('apple_email_$appleId');
  }

  /// Get recent locations (max 6)
  static Future<List<String>> getRecentLocations() async {
    try {
      final locationsStr = await _prefsInstance.getString(_recentLocationsKey);
      if (locationsStr == null || locationsStr.isEmpty) return [];
      // EncryptedSharedPreferences doesn't have getStringList, so we store as comma-separated string
      return locationsStr.split(',');
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// Add a location to recent locations (keeps only last 6)
  static Future<void> addRecentLocation(String location) async {
    try {
      List<String> locations = await getRecentLocations();

      // Remove if already exists to avoid duplicates
      locations.remove(location);

      // Add to the beginning
      locations.insert(0, location);

      // Keep only last 6 locations
      if (locations.length > 6) {
        locations = locations.sublist(0, 6);
      }

      // Store as comma-separated string
      await _prefsInstance.setString(_recentLocationsKey, locations.join(','));
    } catch (e) {
      log(e.toString());
    }
  }

  /// Get recent hotel searches (max 4)
  static Future<List<String>> getRecentHotelSearches() async {
    try {
      final searchesStr = await _prefsInstance.getString(
        _recentHotelSearchesKey,
      );
      if (searchesStr == null || searchesStr.isEmpty) return [];
      // EncryptedSharedPreferences doesn't have getStringList, so we store as comma-separated string
      return searchesStr.split(',');
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// Add a hotel name to recent searches (keeps only last 4)
  static Future<void> addRecentHotelSearch(String hotelName) async {
    try {
      List<String> searches = await getRecentHotelSearches();

      // Remove if already exists to avoid duplicates
      searches.remove(hotelName);

      // Add to the beginning
      searches.insert(0, hotelName);

      // Keep only last 4 searches
      if (searches.length > 4) {
        searches = searches.sublist(0, 4);
      }

      // Store as comma-separated string
      await _prefsInstance.setString(
        _recentHotelSearchesKey,
        searches.join(','),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// Get two-factor authentication status
  static Future<bool> getTwoFactorAuthEnabled() async {
    try {
      final value = await _prefsInstance.getString(_twoFactorAuthEnabled);
      if (value == null) return false;
      return value == 'true';
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  /// Set two-factor authentication status
  static Future<bool> setTwoFactorAuthEnabled(bool enabled) async {
    try {
      await _prefsInstance.setString(_twoFactorAuthEnabled, enabled.toString());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> clearAll({bool shouldPop = true}) async {
    try {
      await _prefsInstance.clear();
      setOnboarding(true);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefsInstance.setString(_userKey, userJson);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<UserModel?> getUser() async {
    try {
      final userJson = await _prefsInstance.getString(_userKey);
      if (userJson == null || userJson.isEmpty) return null;
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
