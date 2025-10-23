import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../screens/edit_wishlist_screen.dart';

class WishlistCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final VoidCallback? onDeleted;
  final VoidCallback? onUpdated;

  const WishlistCard({
    super.key,
    required this.item,
    required this.index,
    this.onDeleted,
    this.onUpdated,
  });

  void _editWishlist(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditWishlistPage(item: item, index: index),
      ),
    );
    if (result != null && onUpdated != null) {
      onUpdated!();
    }
  }

  void _deleteWishlist(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Wishlist'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await DBService.deleteWishlist(index);
      if (onDeleted != null) onDeleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        onTap: () => _editWishlist(context),
        leading: Icon(
          item['achieved'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
          color: item['achieved'] == true ? Colors.green : Colors.grey,
        ),
        title: Text(
          item['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((item['desc'] ?? '').toString().isNotEmpty)
              Text(item['desc']),
            if ((item['category'] ?? '').toString().isNotEmpty)
              Text('Category: ${item['category']}'),
            if ((item['price'] ?? '').toString().isNotEmpty)
              Text('Price: ${item['price']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _editWishlist(context),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deleteWishlist(context),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}