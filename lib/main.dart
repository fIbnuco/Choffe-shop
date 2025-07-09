import 'package:flutter/material.dart';
import 'page/page_home.dart';

// Tambahkan import berikut jika pakai sqflite_common_ffi
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inisialisasi khusus desktop (Windows/Linux)
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}
