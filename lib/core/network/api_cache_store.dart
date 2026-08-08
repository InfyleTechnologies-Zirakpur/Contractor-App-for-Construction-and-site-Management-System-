import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCacheStore {
  Future<void> write(String key, dynamic jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(jsonData));
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }
}