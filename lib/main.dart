import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const SwiftiApp());
}

class SwiftiApp extends StatelessWidget {
  const SwiftiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سويفتي | Swifti',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
      ],
      locale: const Locale('ar', 'AE'),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Cairo',
      ),
      home: const SwiftiHomePage(),
    );
  }
}

class SwiftiHomePage extends StatefulWidget {
  const SwiftiHomePage({Key? key}) : super(key: key);

  @override
  State<SwiftiHomePage> createState() => _SwiftiHomePageState();
}

class _SwiftiHomePageState extends State<SwiftiHomePage> {
  String selectedCity = 'دمشق';
  final List<String> cities = [
    'دمشق',
    'حلب',
    'حمص',
    'اللاذقية',
    'حماة',
    'طرطوس',
    'درعا',
    'الرقة'
  ];

  final List<Map<String, dynamic>> services = [
    {
      'title': 'توصيل مطاعم ووجبات',
      'subtitle': 'أسرع توصيل من أشهى المطاعم',
      'icon': Icons.restaurant,
      'color': Colors.deepOrange,
      'price': 'تبدأ من 5000 ل.س'
    },
    {
      'title': 'مواد غذائية وسوبرماركت',
      'subtitle': 'قضايتك البيتية باب بيتك',
      'icon': Icons.shopping_basket,
      'color': Colors.green,
      'price': 'توصيل فوري'
    },
    {
      'title': 'طرود ووثائق ومستندات',
      'subtitle': 'نقل آمن وسريع بين المناطق',
      'icon': Icons.local_shipping,
      'color': Colors.blue,
      'price': 'حسب المسافة'
    },
    {
      'title': 'صيدلية وطلبات خاصة',
      'subtitle': 'أدوية ومستلزمات طبية طارئة',
      'icon': Icons.local_pharmacy,
      'color': Colors.redAccent,
      'price': 'متوفر 24/7'
    },
  ];

  final List<Map<String, String>> recentOrders = [
    {'id': '#SW-1042', 'status': 'جاري التوصيل', 'item': 'وجبة مطعم - دمشق'},
    {'id': '#SW-1039', 'status': 'تم التوصيل', 'item': 'طلبية سوبرماركت'},
  ];

  void _showOrderDialog(BuildContext context, String serviceName) {
    final TextEditingController detailsController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('طلب جديد: $serviceName', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('المدينة المحددة: $selectedCity', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'العنوان بالتفصيل (المنطقة، الشارع، البناء)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل الطلب أو الملاحظات',
                  border: OutlineInputBorder(),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إرسال طلبك بنجاح في $selectedCity! سيتم التواصل معك قريباً.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('تأكيد وإرسال الطلب', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سويفتي | Swifti - توصيل سوريا', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // بطاقة اختيار المدينة
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text('اختر المدينة / المحافظة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  DropdownButton<String>(
                    value: selectedCity,
                    underline: const SizedBox(),
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // بانر ترحيبي
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أسرع خدمة توصيل في سوريا 🚀',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'اطلب ما تحتاجه من مطاعم، سوبرماركت، أو أرسل طرودك بكل ثقة وسرعة.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // قسم الخدمات
          const Text(
            'خدمات سويفتي المتاحة:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _showOrderDialog(context, service['title']),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: (service['color'] as Color).withOpacity(0.15),
                          child: Icon(service['icon'], size: 30, color: service['color']),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          service['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['subtitle'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service['price'],
                            style: TextStyle(color: Colors.deepOrange.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // قسم الطلبات الأخيرة / التتبع
          const Text(
            'طلباتك النشطة والسابقة:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...recentOrders.map((order) => Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Icon(Icons.delivery_dining, color: Colors.white),
                  ),
                  title: Text(order['item']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('رقم الطلب: ${order['id']}'),
                  trailing: Chip(
                    label: Text(
                      order['status']!,
                      style: TextStyle(
                        color: order['status'] == 'جاري التوصيل' ? Colors.deepOrange : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    backgroundColor: order['status'] == 'جاري التوصيل'
                        ? Colors.deepOrange.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                  ),
                ),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'طلباتي'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
