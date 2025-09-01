import 'package:flutter/material.dart';
import '../models/appointment_model.dart'; // 👈 عدل حسب مكان ملف الموديل

class AppointmentsScreen extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentsScreen({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: const Color(0xFF247CFF),
      ),
      body: appointments.isEmpty
          ? const Center(
        child: Text(
          "No Appointments Yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(
                appointment.type == "Video Call"
                    ? Icons.videocam
                    : appointment.type == "Phone Call"
                    ? Icons.phone
                    : Icons.person,
                color: const Color(0xFF247CFF),
              ),
              title: Text(
                appointment.type,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Start: ${appointment.startTime}"),
                  if (appointment.notes.isNotEmpty)
                    Text("Notes: ${appointment.notes}"),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
