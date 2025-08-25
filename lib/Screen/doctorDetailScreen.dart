// lib/screens/doctor_detail_screen.dart
import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../models/doctor_model.dart';

class DoctorDetailScreen extends StatefulWidget {
  final int doctorId;
  const DoctorDetailScreen({required this.doctorId, super.key});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  late Future<DoctorModel> _doctorFuture;

  @override
  void initState() {
    super.initState();
    _doctorFuture = _loadDoctor();
  }

  Future<DoctorModel> _loadDoctor() async {
    final res = await ApiService.instance.getDoctorById(widget.doctorId);
    final data = res['data'];
    return DoctorModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Detail')),
      body: FutureBuilder<DoctorModel>(
        future: _doctorFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final d = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (d.image != null) Image.network(d.image!),
                const SizedBox(height: 8),
                Text(
                  d.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(d.specialization),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // ✅ التنقل باستخدام pushNamed مع arguments
                    Navigator.pushNamed(
                      context,
                      '/AppointmentScreen',
                      arguments: d.id, // تمرير doctorId
                    );
                  },
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
