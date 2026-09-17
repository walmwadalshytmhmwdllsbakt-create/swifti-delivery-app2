import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SwivelApp());
}

class SwivelApp extends StatelessWidget {
  const SwivelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swivel Delivery',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Cairo',
      ),
      home: const OrderHomeScreen(),
    );
  }
}

class OrderHomeScreen extends StatefulWidget {
  const OrderHomeScreen({super.key});

  @override
  State<OrderHomeScreen> createState() => _OrderHomeScreenState();
}

class _OrderHomeScreenState extends State<OrderHomeScreen> {
  final TextEditingController _orderController = TextEditingController();
  bool _isLoading = false;

  // دالة لإرسال الطلب إلى قاعدة بيانات Firebase Firestore
  Future<void> _sendOrder() async {
    if (_orderController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال تفاصيل الطلب أولاً')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // حفظ الطلب في مجموعة orders داخل Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'details': _orderController.text.trim(),
        'status': 'قيد الانتظار',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _orderController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الطلب بنجاح إلى سويفل!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإرسال: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swivel Delivery | سويفل للتوصيل'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        عضو: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'أهلاً بك في نظام سويفل للتوصيل',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(
                labelText: 'تفاصيل طلب التوصيل (مثال: توصيل طرد إلى حي البستان)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ).let((_) => ElevatedButton(
                      onPressed: _sendOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'إرسال الطلب',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
