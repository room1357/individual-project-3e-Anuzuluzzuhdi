import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String userKey = 'user';
  static const String currentUserKey = 'current_user';

  // Register user (overwrite for simplicity)
  static Future<void> register(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toMap()));
    await prefs.setString(currentUserKey, jsonEncode(user.toMap()));
  }

  // Login user
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(userKey);
    if (userStr == null) return false;
    final userMap = jsonDecode(userStr);
    if (userMap['email'] == email && userMap['password'] == password) {
      await prefs.setString(currentUserKey, jsonEncode(userMap));
      return true;
    }
    return false;
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(currentUserKey);
    if (userStr == null) return null;
    final userMap = jsonDecode(userStr);
    return User.fromMap(userMap);
  }
}