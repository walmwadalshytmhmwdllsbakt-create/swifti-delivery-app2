import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_screen.dart';
import 'profile_screen.dart';

// متحكم بسيط للتبديل بين اللغتين (العربية والإنجليزية)
class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('ar'); // اللغة الافتراضية: العربية
  Locale get locale => _locale;

  void toggleLanguage() {
    if (_locale.languageCode == 'ar') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('ar');
    }
    notifyListeners();
  }
}

final languageController = LanguageController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SwiftiApp());
}

class SwiftiApp extends StatefulWidget {
  const SwiftiApp({super.key});

  @override
  State<SwiftiApp> createState() => _SwiftiAppState();
}

class _SwiftiAppState extends State<SwiftiApp> {
  @override
  void initState() {
    super.initState();
    languageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = languageController.locale.languageCode == 'ar';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageController.locale,
      title: isArabic ? 'تطبيق سويفتي للتوصيل' : 'Swifti Delivery',
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
    final isArabic = languageController.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'سويفتي للتوصيل - Swifti Delivery' : 'Swifti Delivery'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: isArabic ? 'Switch to English' : 'التحويل إلى العربية',
            onPressed: () {
              languageController.toggleLanguage();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'تم ربط تطبيق سويفتي بـ Firebase بنجاح!'
                    : 'Swifti App successfully connected to Firebase!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'يمكنك تبديل اللغة من أيقونة الكرة الأرضية في الأعلى'
                    : 'You can switch language using the globe icon above',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                label: Text(isArabic ? 'الانتقال إلى شاشة الإدارة (Admin)' : 'Go to Admin Screen'),
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
                label: Text(isArabic ? 'الانتقال إلى الملف الشخصي (Profile)' : 'Go to Profile Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
