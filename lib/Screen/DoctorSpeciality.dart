import 'package:flutter/material.dart';

class Doctorspeciality extends StatelessWidget {
  const Doctorspeciality({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Doctor Speciality",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 45),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/generalScreen');
                    },
                    child: specialityItem("assets/General.jpg", "General"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/neurologicScreen');
                    },
                    child:
                    specialityItem("assets/neurologic.jpg", "Neurologic"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/pediatricScreen');
                    },
                    child:
                    specialityItem("assets/pediatric.jpg", "Pediatric"),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/radiologyScreen');
                    },
                    child: specialityItem("assets/Radiology.jpg", "Radiology"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/ENTScreen');
                    },
                    child: specialityItem("assets/ENT.jpg", "ENT"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/DentistryScreen');
                    },
                    child: specialityItem("assets/Dentistry.jpg", "Dentistry"),
                  ),

                ],
              ),


              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/OptometryScreen');
                    },
                    child: specialityItem("assets/Optometry.jpg", "Optometry"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/intestineScreen');
                    },
                    child: specialityItem("assets/intestine.png", "Intestine"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/UrologistScreen');
                    },
                    child: specialityItem("assets/Urologist.jpg", "Urologist"),
                  ),

                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/HepatologyScreen');
                    },
                    child: specialityItem("assets/Hepatology.jpg", "Hepatology"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/histologistScreen');
                    },
                    child: specialityItem("assets/histologist.JPG", "Histologist"),
                  ),
                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/CardiologistScreen');
                    },
                    child: specialityItem("assets/cardiologist.jpg", "Cardiologist"),
                  ),

                ],
              ),


          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/PulmonaryScreen');
                },
                child: specialityItem("assets/pulmonary.jpg", "Pulmonary"),
              ),
              const SizedBox(width: 250)
            ],
          ),
        ]),
      ),
    ));
  }

  static Column specialityItem(String iconPath, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue.shade50,
          backgroundImage: AssetImage(iconPath),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
