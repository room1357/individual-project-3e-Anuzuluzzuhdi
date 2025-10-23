// lib/services/export_service.dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'db_service.dart';

class ExportService {
  /// Helper: request storage permission on Android (if needed).
  static Future<bool> _requestStoragePermissionIfNeeded() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    // iOS/macOS usually don't require explicit storage permission for app directories
    return true;
  }

  /// Helper: get a writable directory path that's accessible.
  /// On Android tries external storage (Downloads) if available, otherwise app documents.
  static Future<Directory> _getWritableDirectory() async {
    if (Platform.isAndroid) {
      // try external storage (may require MANAGE_EXTERNAL_STORAGE for full access on new Android
      // but writing into app-specific directories is safe)
      final extDir = await getExternalStorageDirectory();
      if (extDir != null) return extDir;
    }
    // fallback to application documents dir for iOS, macOS, web (web won't call this)
    return await getApplicationDocumentsDirectory();
  }

  /// Export wishlist to CSV and save to device storage.
  /// Returns the absolute path of created CSV file or null on failure.
  static Future<String?> exportToCSV() async {
    final wishlist = await DBService.getWishlist();

    List<List<dynamic>> rows = [
      ['Title', 'Description', 'Category', 'Price', 'Achieved', 'Achieved Date']
    ];
    for (var item in wishlist) {
      rows.add([
        item['name'] ?? '',
        item['desc'] ?? '',
        item['category'] ?? '',
        item['price'] ?? '',
        (item['achieved'] == true) ? 'Yes' : 'No',
        item['achievedDate'] ?? '',
      ]);
    }
    String csvData = const ListToCsvConverter().convert(rows);

    // Request storage permission (Android)
    final ok = await _requestStoragePermissionIfNeeded();
    if (!ok) return null;

    final dir = await _getWritableDirectory();
    final filename = 'wishlist_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final path = '${dir.path}/$filename';
    final file = File(path);
    await file.writeAsString(csvData);

    return path;
  }

  /// Export wishlist to PDF and save to device storage.
  /// Returns the absolute path of created PDF file or null on failure.
  static Future<String?> exportToPDF() async {
    final wishlist = await DBService.getWishlist();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Wishlist Export',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Title', 'Description', 'Category', 'Price', 'Achieved', 'Achieved Date'],
              data: wishlist.map((item) => [
                item['name'] ?? '',
                item['desc'] ?? '',
                item['category'] ?? '',
                item['price'] ?? '',
                (item['achieved'] == true) ? 'Yes' : 'No',
                item['achievedDate'] ?? '',
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],
        ),
        pageFormat: PdfPageFormat.a4,
      ),
    );

    // Request storage permission (Android)
    final ok = await _requestStoragePermissionIfNeeded();
    if (!ok) return null;

    final dir = await _getWritableDirectory();
    final filename = 'wishlist_export_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final path = '${dir.path}/$filename';
    final file = File(path);
    final bytes = await pdf.save();
    await file.writeAsBytes(bytes);

    return path;
  }
}
