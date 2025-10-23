import 'package:flutter/material.dart';
import '../services/db_service.dart' as db;
import '../services/export_service.dart'; // Tambahkan import jika ingin akses langsung
import 'package:fluttertoast/fluttertoast.dart'; // Untuk feedback sederhana (opsional)
//import '../widgets/wishlist_card.dart';
import '../screens/add_wishlist_screen.dart';
import 'category_screen.dart';
import 'login_screen.dart';
import 'wishlist_screen.dart';
import 'statistic_screen.dart';
import 'profile_screen.dart';

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

  void _goToCategoryPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryPage()),
    );
    _loadWishlist();
  }

  void _goToWishlistListPage() async {
    await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WishlistListPage()),
  );
  _loadWishlist();
  }

  void _goToStatisticScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatisticScreen()),
    );
  }

  void _goToProfileScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _goToExportDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Export Wishlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export to CSV'),
              onTap: () async {
                Navigator.pop(ctx);
                final path = await ExportService.exportToCSV();
                Fluttertoast.showToast(
                  msg: path != null ? 'CSV exported to $path' : 'Export failed',
                  toastLength: Toast.LENGTH_LONG,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export to PDF'),
              onTap: () async {
                Navigator.pop(ctx);
                final path = await ExportService.exportToPDF();
                Fluttertoast.showToast(
                  msg: path != null ? 'PDF exported to $path' : 'Export failed',
                  toastLength: Toast.LENGTH_LONG,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _goToWishlistListPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Color(0xFF6D5DF6)),
              title: Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                _goToCategoryPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF6D5DF6)),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _goToProfileScreen();
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Card: Profile
          GestureDetector(
            onTap: _goToProfileScreen,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.12),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.account_circle, color: Colors.white, size: 40),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View your account information',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                ],
              ),
            ),
          ),
          // Card 1: My Wishlist
          GestureDetector(
            onTap: _goToWishlistListPage,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.shade100,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite_border, color: Colors.white, size: 40),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'My Wishlist',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View and manage your wishlist items',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                ],
              ),
            ),
          ),
          // Card 2: Categories
          GestureDetector(
            onTap: _goToCategoryPage,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.category, color: Colors.white, size: 40),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View and manage your expense categories',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                ],
              ),
            ),
          ),
          // Card 3: Statistics
          GestureDetector(
            onTap: _goToStatisticScreen,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.12),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.deepPurple, size: 40),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Overview of your wishlist and expenses',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                ],
              ),
            ),
          ),
          // Card: Export Data
          GestureDetector(
            onTap: _goToExportDialog,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.file_download, color: Colors.grey, size: 40),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Export Data',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Export your wishlist to CSV or PDF',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}