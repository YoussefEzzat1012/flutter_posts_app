import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    return await _prefs?.setString(key, jsonEncode(value)) ?? false;
  }

  static Map<String, dynamic>? getObject(String key) {
    final data = _prefs?.getString(key);
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}