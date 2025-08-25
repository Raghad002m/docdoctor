// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../models/doctor_model.dart';


// شاشات ثانية
import 'MessagesScreen.dart';
import 'NotificationScreen.dart';
import 'SearchScreen.dart';
import 'doctorDetailScreen.dart';
import 'profileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<DoctorModel>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = _loadDoctors();
  }

  Future<List<DoctorModel>> _loadDoctors() async {
    final data = await ApiService.instance.getDoctors();
    return data
        .map<DoctorModel>((e) => DoctorModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      // الصفحة الرئيسية مع دمج API
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الترحيب + الإشعارات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hi",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("How Are you Today?",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()),
                    );
                  },
                  child: const Icon(Icons.notifications_none, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // الكرت الأزرق
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Book and schedule with nearest doctor",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("Find Nearby"),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    "assets/Doctor.png",
                    width: 130,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Doctor Speciality
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Doctor Speciality",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/DoctorSpeciality');
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/generalScreen');
                    },
                    child: specialityItem("assets/General.jpg", "General")),
                const SizedBox(width: 25),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/neurologicScreen');
                    },
                    child: specialityItem("assets/neurologic.jpg", "Neurologic")),
                const SizedBox(width: 25),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/pediatricScreen');
                    },
                    child: specialityItem("assets/pediatric.jpg", "Pediatric")),
                const SizedBox(width: 25),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/radiologyScreen');
                    },
                    child: specialityItem("assets/Radiology.jpg", "Radiology")),
              ],
            ),
            const SizedBox(height: 15),

            // Recommendation Doctor (من API)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recommendation Doctor",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/RecommendationDoctor');
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // قائمة الأطباء من API
            SizedBox(
              height: 250,
              child: FutureBuilder<List<DoctorModel>>(
                future: _doctorsFuture,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  final doctors = snap.data ?? [];
                  if (doctors.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: doctors.length,
                    itemBuilder: (context, i) {
                      final d = doctors[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DoctorDetailScreen(doctorId: d.id),
                          ),
                        ),
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue.shade50,
                          ),
                          child: Column(
                            children: [
                              d.image != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(d.image!,
                                    height: 80, width: 80, fit: BoxFit.cover),
                              )
                                  : const Icon(Icons.person, size: 80),
                              const SizedBox(height: 10),
                              Text(d.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(d.specialization,
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      const MessagesScreen(),
      const SearchScreen(),
      const Center(child: Text("📅 Appointments")),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _pages[_selectedIndex]),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 40, color: Colors.blue),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: ''),
        ],
      ),
    );
  }

  // ويدجت مساعدة للتخصصات
  static Column specialityItem(String iconPath, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade50,
          backgroundImage: AssetImage(iconPath),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
