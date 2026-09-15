import 'package:flutter/material.dart';

void main() {
  runApp(const SwiftiApp());
}

class SwiftiApp extends StatelessWidget {
  const SwiftiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سويفتي | Swifti',
      theme: ThemeData(
        primaryColor: const Color(0xFF007A3D), // الأخضر الأساسي
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007A3D),
          primary: const Color(0xFF007A3D),      // أخضر
          secondary: const Color(0xFFCE1126),    // أحمر
          tertiary: Colors.black,               // أسود
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF007A3D),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سويفتي | Swifti'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'مرحباً بك في تطبيق سويفتي',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
