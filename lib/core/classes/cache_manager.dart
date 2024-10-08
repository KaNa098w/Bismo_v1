import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      log("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<double?> readDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    double? obj = prefs.getDouble(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool obj = prefs.containsKey(key);
    return obj;
  }
}
