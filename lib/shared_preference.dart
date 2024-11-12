import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefs {

  static String name = "name";
  static String phoneNumber = "phoneNumber";
  static String userPass = "userPass";
  static String userId = "userId";
  static String token = "token";
  static String userAccessLevel = "userAccessLevel";

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter for checking if SharedPreferences is initialized
  static bool get isInitialized => _prefs != null;

  // Set a value in SharedPreferences
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Get a value from SharedPreferences
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Other setters and getters can be similarly created for different data types
  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
