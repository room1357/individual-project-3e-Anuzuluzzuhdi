# Pemrograman Mobile - Individual Project

## About Me

**Nama:** Abhinaya Nuzuluzzuhdi  
**NIM:** 2341760182 
**Kelas:** SIB 3E / 01 

## Project Overview

Aplikasi ini adalah proyek individu untuk mata kuliah Pemrograman Mobile.  
Aplikasi ini merupakan aplikasi **Wishlist & Expense Tracker** sederhana berbasis Flutter, yang memungkinkan pengguna untuk:

- Menambah, mengedit, dan menghapus wishlist barang impian.
- Mengelompokkan wishlist berdasarkan kategori.
- Melihat statistik progress wishlist (total, tercapai, per kategori).
- Menyimpan data secara lokal (SharedPreferences).
- Ekspor data wishlist ke file CSV atau PDF.
- Fitur user login/register agar wishlist bersifat personal.
- Melihat dan mengedit profil pengguna.

## Fitur Utama

- **Manajemen Wishlist:** Tambah, edit, hapus, tandai tercapai, dan detail wishlist.
- **Kategori:** Kelola kategori wishlist, filter dan grouping berdasarkan kategori.
- **Statistik:** Visualisasi progress wishlist dengan pie chart (fl_chart).
- **Ekspor Data:** Ekspor wishlist ke CSV/PDF dan simpan ke storage.
- **User Management:** Register, login, logout, dan profile user.
- **UI Modern:** Navigasi mudah, tampilan cards, dan drawer menu.

## Teknologi & Package

- **Flutter** (Dart)
- **SharedPreferences** (local storage)
- **fl_chart** (statistik/pie chart)
- **csv** & **pdf** (ekspor data)
- **path_provider**, **permission_handler**, **flutter_file_saver** (akses file)
- **fluttertoast** (notifikasi)
- **uuid** (ID unik)
- **intl** (format tanggal)
- **flutter_colorpicker** (pilih warna kategori)

## Cara Menjalankan

1. Clone repository ini.
2. Jalankan `flutter pub get` untuk menginstall dependencies.
3. Jalankan aplikasi dengan `flutter run`.

## Catatan

- Untuk fitur ekspor, pastikan sudah mengatur permission storage pada Android.
- Semua data disimpan secara lokal di device.

---

> _Proyek ini dibuat untuk memenuhi tugas individu
