import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../widgets/wishlist_card.dart';
import '../screens/add_wishlist_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final data = await DBService.getWishlist();
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
    final List<Color> cardColors = [
      Color(0xFF6D5DF6), // Ungu
      Color(0xFF3D8CE7), // Biru
      Color(0xFF00C9A7), // Tosca
      Color(0xFFFFB259), // Orange
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xFF6D5DF6),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6D5DF6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF6D5DF6)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Color(0xFF6D5DF6)),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Color(0xFF6D5DF6)),
              title: Text('My Wishlist'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box, color: Color(0xFF6D5DF6)),
              title: Text('Add Item'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_events, color: Color(0xFF6D5DF6)),
              title: Text('Achieved'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF6D5DF6)),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _wishlist.isEmpty
            ? Center(child: Text('No wishlist items yet.'))
            : ListView.builder(
                itemCount: _wishlist.length,
                itemBuilder: (context, index) => WishlistCard(
                  item: _wishlist[index],
                  index: index,
                  onDeleted: _loadWishlist,
                  onUpdated: _loadWishlist,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddWishlist,
        backgroundColor: Color(0xFF6D5DF6),
        child: const Icon(Icons.add),
        tooltip: 'Add Wishlist',
      ),
    );
  }
}