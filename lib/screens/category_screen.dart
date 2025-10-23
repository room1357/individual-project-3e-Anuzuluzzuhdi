import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
//import '../services/db_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> _categories = [];
  Map<String, int> _wishlistCount = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadWishlistCount();
  }

  Future<void> _loadCategories() async {
    final cats = await DBService.getCategories();
    setState(() {
      _categories = cats.map((e) => Category.fromMap(jsonDecode(e))).toList();
    });
  }

  Future<void> _loadWishlistCount() async {
    final wishlists = await DBService.getWishlist();
    final Map<String, int> count = {};
    for (var item in wishlists) {
      final cat = item['category'] ?? '';
      count[cat] = (count[cat] ?? 0) + 1;
    }
    setState(() {
      _wishlistCount = count;
    });
  }

  Future<void> _addOrEditCategory({Category? category}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    Color selectedColor = category != null ? Color(category.color) : Colors.blue;
    final result = await showDialog<Category>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Color: '),
                GestureDetector(
                  onTap: () async {
                    final color = await showDialog<Color>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: selectedColor,
                            onColorChanged: (c) {
                              Navigator.of(ctx).pop(c);
                            },
                          ),
                        ),
                      ),
                    );
                    if (color != null) {
                      selectedColor = color;
                      (ctx as Element).markNeedsBuild();
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              final newCat = Category(
                id: category?.id ?? const Uuid().v4(),
                name: nameController.text.trim(),
                color: selectedColor.value,
              );
              Navigator.pop(ctx, newCat);
            },
            child: Text(category == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
    if (result != null) {
      if (category == null) {
        await DBService.addCategory(jsonEncode(result.toMap()));
      } else {
        await DBService.updateCategory(result.id, jsonEncode(result.toMap()));
      }
      _loadCategories();
      _loadWishlistCount();
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await DBService.deleteCategory(category.id);
      _loadCategories();
      _loadWishlistCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color(0xFF3D8CE7),
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return CategoryCard(
            category: cat,
            wishlistCount: _wishlistCount[cat.name] ?? 0,
            onEdit: () => _addOrEditCategory(category: cat),
            onDelete: () => _deleteCategory(cat),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditCategory(),
        backgroundColor: const Color(0xFF3D8CE7),
        child: const Icon(Icons.add),
        tooltip: 'Add Category',
      ),
    );
  }
}

// Tambahan pada DBService
class DBService {
  static const String categoryKey = 'categories';

  static Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(categoryKey) ?? [];
  }

  static Future<List<Map<String, dynamic>>> getWishlist() async {
    return [];
    // Implementasi untuk mengambil wishlist
  }

  static Future<void> addCategory(String categoryJson) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> categories = prefs.getStringList(categoryKey) ?? [];
    categories.add(categoryJson);
    await prefs.setStringList(categoryKey, categories);
  }

  static Future<void> updateCategory(String id, String updatedCategoryJson) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> categories = prefs.getStringList(categoryKey) ?? [];
    final idx = categories.indexWhere((e) => jsonDecode(e)['id'] == id);
    if (idx != -1) {
      categories[idx] = updatedCategoryJson;
      await prefs.setStringList(categoryKey, categories);
    }
  }

  static Future<void> deleteCategory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> categories = prefs.getStringList(categoryKey) ?? [];
    categories.removeWhere((e) => jsonDecode(e)['id'] == id);
    await prefs.setStringList(categoryKey, categories);
  }
}