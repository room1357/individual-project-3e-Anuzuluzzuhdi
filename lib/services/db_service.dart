import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DBService {
  static const String wishlistKey = 'wishlist';
  static const String categoryKey = 'categories';

  // Wishlist Functions

  static Future<List<Map<String, dynamic>>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistStr = prefs.getStringList(wishlistKey) ?? [];
    return wishlistStr.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> addWishlist(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistStr = prefs.getStringList(wishlistKey) ?? [];
    wishlistStr.add(jsonEncode(item));
    await prefs.setStringList(wishlistKey, wishlistStr);
  }

  static Future<void> updateWishlist(int index, Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistStr = prefs.getStringList(wishlistKey) ?? [];
    if (index >= 0 && index < wishlistStr.length) {
      wishlistStr[index] = jsonEncode(item);
      await prefs.setStringList(wishlistKey, wishlistStr);
    }
  }

  static Future<void> deleteWishlist(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistStr = prefs.getStringList(wishlistKey) ?? [];
    if (index >= 0 && index < wishlistStr.length) {
      wishlistStr.removeAt(index);
      await prefs.setStringList(wishlistKey, wishlistStr);
    }
  }

  // Category Functions

  static Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(categoryKey) ?? [];
  }

  // Hindari duplikat
  static Future<void> addCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> categories = prefs.getStringList(categoryKey) ?? [];
    if (!categories.contains(category)) {
      categories.add(category);
      await prefs.setStringList(categoryKey, categories);
    }
  }

  // Hapus kategori tertentu
  static Future<void> deleteCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> categories = prefs.getStringList(categoryKey) ?? [];
    categories.remove(category);
    await prefs.setStringList(categoryKey, categories);
  }
}