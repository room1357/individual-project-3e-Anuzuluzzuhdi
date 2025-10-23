import 'package:flutter/material.dart';
import '../services/db_service.dart' as db;
import 'add_wishlist_screen.dart';

class WishlistListPage extends StatefulWidget {
  const WishlistListPage({super.key});

  @override
  State<WishlistListPage> createState() => _WishlistListPageState();
}

class _WishlistListPageState extends State<WishlistListPage> {
  List<Map<String, dynamic>> _wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final data = await db.DBService.getWishlist();
    setState(() {
      _wishlist = data;
    });
  }

  void _goToAddWishlist() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWishlistPage()),
    );
    if (result != null) {
      _loadWishlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: const Color(0xFF6D5DF6),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6D5DF6),
        onPressed: _goToAddWishlist,
        child: const Icon(Icons.add),
      ),
      body: _wishlist.isEmpty
          ? const Center(child: Text('No wishlist yet. Tap + to add one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wishlist.length,
              itemBuilder: (context, index) {
                final item = _wishlist[index];
                return Card(
                  child: ListTile(
                    title: Text(item['title'] ?? 'Untitled'),
                    subtitle: Text(item['description'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
