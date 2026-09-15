import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_screen.dart';
import 'profile_screen.dart';

void main() async {
  // ضمان تهيئة محركات فلاتر قبل الاتصال بالخدمات
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة اتصال فايربيز مع التطبيق
  await Firebase.initializeApp();

  runApp(const SwiftiApp());
}

class SwiftiApp extends StatelessWidget {
  const SwiftiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swifti Delivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainHomeWrapper(),
    );
  }
}

class MainHomeWrapper extends StatelessWidget {
  const MainHomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swifti Delivery - سويفتي'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'تم ربط تطبيق سويفتي بـ Firebase بنجاح!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminScreen()),
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('الانتقال إلى شاشة الإدارة (Admin)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              icon: const Icon(Icons.person),
              label: const Text('الانتقال إلى الملف الشخصي (Profile)'),
            ),
          ],
        ),
      ),
    );
  }
}
