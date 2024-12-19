import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
    await clearInvalidData();
  }

  static Future<void> clearInvalidData() async {
    try {
      // Try to read important flags
      bool? isLoginSuccess = _instance.getBool('isLoginSuccess');
      bool? isOnboardingViewSeen = _instance.getBool('isOnboardingViewSeen');
      bool? isUserLogout = _instance.getBool('isUserLogout');
      String? userData = _instance.getString('userData');

      // If any of these are null when they shouldn't be, clear all data
      if (isLoginSuccess == null || isOnboardingViewSeen == null || isUserLogout == null) {
        await _instance.clear();
        // Reset to default values
        await _instance.setBool('isLoginSuccess', false);
        await _instance.setBool('isOnboardingViewSeen', false);
        await _instance.setBool('isUserLogout', false);
        await _instance.setString('userData', '');
      }
    } catch (e) {
      debugPrint('Error clearing invalid data: $e');
    }
  }

  static Future<void> setBool(String key, bool value) async {
    await _instance.setBool(key, value);
  }

  static bool getBool(String key) {
    return _instance.getBool(key) ?? false;
  }

  static Future<void> setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  static String? getString(String key) {
    return _instance.getString(key);
  }

  static Future<void> remove(String key) async {
    await _instance.remove(key);
  }
}
