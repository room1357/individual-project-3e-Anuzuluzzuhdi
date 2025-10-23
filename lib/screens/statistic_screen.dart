import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/db_service.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int totalWishlist = 0;
  int achievedWishlist = 0;
  Map<String, int> categoryCount = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final wishlist = await DBService.getWishlist();
    setState(() {
      totalWishlist = wishlist.length;
      achievedWishlist = wishlist.where((item) => item['achieved'] == true).length;
      categoryCount = {};
      for (var item in wishlist) {
        final cat = (item['category'] ?? 'Uncategorized').toString();
        categoryCount[cat] = (categoryCount[cat] ?? 0) + 1;
      }
    });
  }

  List<PieChartSectionData> _buildPieSections() {
    final colors = [
      Colors.purpleAccent,
      Colors.teal,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.amber,
      Colors.pink,
      Colors.cyan,
      Colors.indigo,
    ];
    int i = 0;
    return categoryCount.entries.map((entry) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: entry.key,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Statistics'),
        backgroundColor: const Color(0xFF6D5DF6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Total Wishlist', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('$totalWishlist', style: const TextStyle(fontSize: 22, color: Colors.purple)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Achieved', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('$achievedWishlist', style: const TextStyle(fontSize: 22, color: Colors.teal)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Wishlist by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: categoryCount.isEmpty
                  ? const Center(child: Text('No data to display'))
                  : PieChart(
                      PieChartData(
                        sections: _buildPieSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(enabled: true),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            // Legend
            if (categoryCount.isNotEmpty)
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: categoryCount.keys.toList().asMap().entries.map((entry) {
                  final i = entry.key;
                  final cat = entry.value;
                  final color = [
                    Colors.purpleAccent,
                    Colors.teal,
                    Colors.orange,
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                    Colors.amber,
                    Colors.pink,
                    Colors.cyan,
                    Colors.indigo,
                  ][i % 10];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 16, height: 16, color: color),
                      const SizedBox(width: 6),
                      Text(cat, style: const TextStyle(fontSize: 14)),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}