import 'package:flutter/material.dart';
import '../booking/bookingstep3.dart';
import '../models/doctor_model.dart';
import '../services/api_service.dart';

class DoctorListScreen extends StatefulWidget {
  final String specialization;

  const DoctorListScreen({super.key, required this.specialization});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Doctor>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    // ✅ جلب الدكاترة حسب اسم التخصص
    _doctorsFuture = _apiService.getDoctorsBySpecializationName(widget.specialization);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.specialization)),
      body: FutureBuilder<List<Doctor>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No doctors found."));
          }

          final doctors = snapshot.data!;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return ListTile(
                leading: const Icon(Icons.person, size: 40),
                title: Text(doctor.name),
                subtitle: Text(doctor.specialization ?? ""),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFlow(
                        doctorId: doctor.id,
                        doctorName: doctor.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
