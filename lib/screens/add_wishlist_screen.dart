import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  final Map<String, dynamic>? existingItem; // Untuk mode edit

  const AddItemScreen({super.key, this.existingItem});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _targetDate;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _nameController.text = widget.existingItem!['name'] ?? '';
      _descController.text = widget.existingItem!['desc'] ?? '';
      if (widget.existingItem!['targetDate'] != null && widget.existingItem!['targetDate'] != '') {
        _targetDate = DateTime.tryParse(widget.existingItem!['targetDate']);
      }
      if (widget.existingItem!['imagePath'] != null && widget.existingItem!['imagePath'] != '') {
        _imageFile = File(widget.existingItem!['imagePath']);
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistStr = prefs.getStringList('wishlist') ?? [];
    List<Map<String, dynamic>> wishlist = wishlistStr.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    final newItem = {
      'name': _nameController.text,
      'desc': _descController.text,
      'targetDate': _targetDate?.toIso8601String() ?? '',
      'imagePath': _imageFile?.path ?? '',
      'achieved': false,
      'achievedDate': '',
    };

    wishlist.add(newItem);
    final newWishlistStr = wishlist.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('wishlist', newWishlistStr);

    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Wishlist'),
        backgroundColor: const Color(0xFF6D5DF6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Wishlist
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Wishlist Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              // Deskripsi
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

              // Date Picker
              ListTile(
                leading: const Icon(Icons.date_range),
                title: Text(_targetDate == null
                    ? 'Target Date (optional)'
                    : 'Target: ${_targetDate!.toLocal().toString().split(' ')[0]}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: _pickDate,
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 8),

              // Image Picker
              ListTile(
                leading: const Icon(Icons.image),
                title: Text(_imageFile == null
                    ? 'Upload Image (optional)'
                    : 'Image Selected'),
                trailing: _imageFile != null
                    ? Image.file(_imageFile!, width: 40, height: 40, fit: BoxFit.cover)
                    : null,
                onTap: _pickImage,
              ),
              const SizedBox(height: 24),

              // Tombol
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D5DF6),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}