import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwiftiMainScreen extends StatefulWidget {
  const SwiftiMainScreen({Key? key}) : super(key: key);

  @override
  State<SwiftiMainScreen> createState() => _SwiftiMainScreenState();
}

class _SwiftiMainScreenState extends State<SwiftiMainScreen> {
  int _tapCount = 0;
  int _pinAttemptLevel = 1;

  String pin1 = '1111';
  String pin2 = '2222';
  String pin3 = '3333';
  final String masterPassword = 'qLCKr$ssFu@12fP';

  @override
  void initState() {
    super.initState();
    _loadSavedPins();
  }

  Future<void> _loadSavedPins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pin1 = prefs.getString('admin_pin1') ?? '1111';
      pin2 = prefs.getString('admin_pin2') ?? '2222';
      pin3 = prefs.getString('admin_pin3') ?? '3333';
    });
  }

  Future<void> _saveNewPins(String p1, String p2, String p3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_pin1', p1);
    await prefs.setString('admin_pin2', p2);
    await prefs.setString('admin_pin3', p3);
    setState(() {
      pin1 = p1;
      pin2 = p2;
      pin3 = p3;
    });
  }

  void _onTopRightCornerTapped() {
    _tapCount++;
    if (_tapCount == 5) {
      _tapCount = 0;
      _pinAttemptLevel = 1;
      _showPinDialog();
    }
  }

  void _showPinDialog() {
    TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('لوحة الإدارة - المستوى $_pinAttemptLevel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('أدخل الرمز السري رقم $_pinAttemptLevel:'),
              const SizedBox(height: 10),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'أدخل الرمز أو كلمة المرور الرئيسية',
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showMasterPasswordDialog();
                },
                child: const Text(
                  'هل نسيت الأكواد؟ الدخول بكلمة المرور الرئيسية',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredPin = pinController.text;

                if (_pinAttemptLevel == 1) {
                  if (enteredPin == pin1) {
                    Navigator.pop(context);
                    _openAdminPanel();
                  } else {
                    _pinAttemptLevel = 2;
                    Navigator.pop(context);
                    _showMsg('الرمز الأول خاطئ، أدخل الرمز الثاني');
                    _showPinDialog();
                  }
                } else if (_pinAttemptLevel == 2) {
                  if (enteredPin == pin2) {
                    Navigator.pop(context);
                    _openAdminPanel();
                  } else {
                    _pinAttemptLevel = 3;
                    Navigator.pop(context);
                    _showMsg('الرمز الثاني خاطئ، أدخل الرمز الثالث والأخير');
                    _showPinDialog();
                  }
                } else if (_pinAttemptLevel == 3) {
                  if (enteredPin == pin3) {
                    _pinAttemptLevel = 1;
                    Navigator.pop(context);
                    _openAdminPanel();
                  } else {
                    _pinAttemptLevel = 1;
                    Navigator.pop(context);
                    _showMsg('تم إدخال رمز خاطئ 3 مرات، تم الإغلاق.');
                  }
                }
              },
              child: const Text('تحقق'),
            ),
          ],
        );
      },
    );
  }

  // نافذة الاستعادة عبر كلمة المرور الرئيسية
  void _showMasterPasswordDialog() {
    TextEditingController masterCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('استعادة عبر كلمة المرور الرئيسية'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('أدخل كلمة المرور الرئيسية لفتح لوحة التحكم:'),
              const SizedBox(height: 10),
              TextField(
                controller: masterCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'كلمة المرور الرئيسية',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (masterCtrl.text == masterPassword) {
                  _pinAttemptLevel = 1;
                  Navigator.pop(context);
                  _openAdminPanel();
                } else {
                  Navigator.pop(context);
                  _showMsg('كلمة المرور الرئيسية خاطئة!');
                }
              },
              child: const Text('دخول'),
            ),
          ],
        );
      },
    );
  }

  void _showMsg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _openAdminPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPanelScreen(
          currentPin1: pin1,
          currentPin2: pin2,
          currentPin3: pin3,
          onSavePins: (p1, p2, p3) {
            _saveNewPins(p1, p2, p3);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سويفتي | Swifti Delivery'),
        backgroundColor: const Color(0xFF007A3D),
        actions: [
          GestureDetector(
            onTap: _onTopRightCornerTapped,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              child: const Icon(Icons.local_shipping, color: Colors.white),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'أهلاً بك في تطبيق سويفتي للتوصيل',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AdminPanelScreen extends StatefulWidget {
  final String currentPin1;
  final String currentPin2;
  final String currentPin3;
  final Function(String, String, String) onSavePins;

  const AdminPanelScreen({
    Key? key,
    required this.currentPin1,
    required this.currentPin2,
    required this.currentPin3,
    required this.onSavePins,
  }) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late TextEditingController p1Ctrl;
  late TextEditingController p2Ctrl;
  late TextEditingController p3Ctrl;

  @override
  void initState() {
    super.initState();
    p1Ctrl = TextEditingController(text: widget.currentPin1);
    p2Ctrl = TextEditingController(text: widget.currentPin2);
    p3Ctrl = TextEditingController(text: widget.currentPin3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المدير - الإعدادات'),
        backgroundColor: const Color(0xFF007A3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'تغيير رموز الأمان الثلاثة (PIN 1, PIN 2, PIN 3):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: p1Ctrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'الرمز الأول (PIN 1)'),
            ),
            TextField(
              controller: p2Ctrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'الرمز الثاني (PIN 2)'),
            ),
            TextField(
              controller: p3Ctrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'الرمز الثالث (PIN 3)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007A3D)),
              onPressed: () {
                widget.onSavePins(p1Ctrl.text, p2Ctrl.text, p3Ctrl.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ الأكواد الجديدة بنجاح!')),
                );
              },
              child: const Text('حفظ الأكواد الجديدة', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
