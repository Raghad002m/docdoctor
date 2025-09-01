import 'package:docdoctor/screen/Home/specialtyGetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Allspecialitiesscreen extends StatelessWidget {
  final List<Map<String, String>> specialties = [
    {"label": "General", "icon": "assets/General.jpg"},
    {"label": "ENT", "icon": "assets/ENT.jpg"},
    {"label": "Pediatric", "icon": "assets/pediatric.jpg"},
    {"label": "Urologist", "icon": "assets/Urologist.jpg"},
    {"label": "Dentistry", "icon": "assets/Dentistry.jpg"},
    {"label": "Intestine", "icon": "assets/intestine.png"},
    {"label": "Histologist", "icon": "assets/histologist.JPG"},
    {"label": "Hepatology", "icon": "assets/Hepatology.jpg"},
    {"label": "Cardiologist", "icon": "assets/cardiologist.jpg"},
    {"label": "Neurologic", "icon": "assets/neurologic.jpg"},
    {"label": "Pulmonary", "icon": "assets/pulmonary.jpg"},
    {"label": "Optometry", "icon": "assets/Optometry.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Speciality"),
        backgroundColor: const Color(0xFF247CFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: specialties.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 17,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = specialties[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpecialtyDetailScreen(
                      label: item['label']!,
                      iconPath: item['icon']!,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45, // حجم الدائرة
                    backgroundImage: AssetImage(item['icon']!), // الصورة نفسها
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['label']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
