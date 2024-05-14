import 'dart:async';

import 'package:vocab_app/configs/application.dart';

class LocalPref {
  
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get showRecentWord => _controller.stream;

  void setShowRecentWord(bool value) async {
    Application.preferences.setBool('showRecentWord', value);
    _controller.add(value); // update value here.
  }

  Future<bool> getShowRecentWord() async {
    return Application.preferences.getBool('showRecentWord') ?? false;
  }

  static Future<bool> clear() {
    return Application.preferences.clear();
  }

  static bool containsKey(String key) {
    return Application.preferences.containsKey(key);
  }

  static dynamic get(String key) {
    return Application.preferences.get(key);
  }

  static bool? getBool(String key) {
    return Application.preferences.getBool(key);
  }

  static double? getDouble(String key) {
    return Application.preferences.getDouble(key);
  }

  static int? getInt(String key) {
    return Application.preferences.getInt(key);
  }

  static Set<String> getKeys() {
    return Application.preferences.getKeys();
  }

  static String? getString(String key) {
    return Application.preferences.getString(key);
  }

  static List<String>? getStringList(String key) {
    return Application.preferences.getStringList(key);
  }

  static Future<void> reload() {
    return Application.preferences.reload();
  }

  static Future<bool> remove(String key) {
    return Application.preferences.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return Application.preferences.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return Application.preferences.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return Application.preferences.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return Application.preferences.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return Application.preferences.setStringList(key, value);
  }

  void dispose() => _controller.close();

  ///Singleton factory
  static final LocalPref _instance = LocalPref._internal();

  factory LocalPref() {
    return _instance;
  }

  LocalPref._internal();
}
