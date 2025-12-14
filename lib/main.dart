import 'package:depd_alp/ProfilePage.dart';
import 'package:flutter/material.dart';// Import halaman event di sini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event UI Clone',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD), // Light greyish background
      ),
      home: const ProfilePage(), // Memanggil HomePage dari file eventpage.dart
    );
  }
}