import 'package:docdoctor/Screen/profileScreen.dart';
import 'package:flutter/material.dart';

import 'NotificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 4) {
      // لو ضغطت على آخر أيقونة → افتح البروفايل
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
      // الصفحة الرئيسية
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hi",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "How Are you Today?",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationScreen()),
                    );
                  },
                  child: const Icon(Icons.notifications_none, size: 28),
                ),

              ],
            ),
            const SizedBox(height: 20),
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
                  child: specialityItem("assets/General.jpg", "General"),
                ),
                const SizedBox(width: 25),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/neurologicScreen');
                  },
                  child: specialityItem("assets/neurologic.jpg", "Neurologic"),
                ),
                const SizedBox(width: 25),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/pediatricScreen');
                  },
                  child: specialityItem("assets/pediatric.jpg", "Pediatric"),
                ),
                const SizedBox(width: 25),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/radiologyScreen');
                  },
                  child: specialityItem("assets/Radiology.jpg", "Radiology"),
                ),
              ],
            ),
            const SizedBox(height: 15),

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
          ],
        ),
      ),

      const Center(child: Text("💬 Chats")),
      const Center(child: Text("🔍 Search")),
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

  // Widget Helper
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
