import 'package:flutter/material.dart';
import '../services/db_service.dart';

class EditWishlistPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;

  const EditWishlistPage({super.key, required this.item, required this.index});

  @override
  State<EditWishlistPage> createState() => _EditWishlistPageState();
}

class _EditWishlistPageState extends State<EditWishlistPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item['name'] ?? '');
    _descController = TextEditingController(text: widget.item['desc'] ?? '');
    _priceController = TextEditingController(text: widget.item['price'] ?? '');
    _selectedCategory = widget.item['category'] ?? '';
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await DBService.getCategories();
    setState(() {
      _categories = cats;
    });
  }

  Future<void> _updateWishlist() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = {
        ...widget.item,
        'name': _titleController.text,
        'desc': _descController.text,
        'category': _selectedCategory ?? '',
        'price': _priceController.text,
      };
      await DBService.updateWishlist(widget.index, updatedItem);
      if (mounted) Navigator.pop(context, updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Wishlist Item'),
        backgroundColor: const Color(0xFF6D5DF6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateWishlist,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D5DF6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}