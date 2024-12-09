import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> saveData<T>(String key, T data) async {
    if (data is String) {
      return await _prefs.setString(key, data);
    } else if (data is int) {
      return await _prefs.setInt(key, data);
    } else if (data is double) {
      return await _prefs.setDouble(key, data);
    } else if (data is bool) {
      return await _prefs.setBool(key, data);
    } else if (data is List<String>) {
      return await _prefs.setStringList(key, data);
    } else {
      // For complex objects
      final jsonString = json.encode(data);
      return await _prefs.setString(key, jsonString);
    }
  }

  T? getData<T>(String key) {
    try {
      if (T == String) {
        return _prefs.getString(key) as T?;
      } else if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == List<String>) {
        return _prefs.getStringList(key) as T?;
      } else {
        // For complex objects
        final jsonString = _prefs.getString(key);
        if (jsonString != null) {
          return json.decode(jsonString) as T?;
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
    return null;
  }

  Future<bool> removeData(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }
}
