// lib/screens/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/services/api_service.dart';

class AppointmentScreen extends StatefulWidget {
  final int doctorId;

  const AppointmentScreen({required this.doctorId, super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();

  /// ✅ Factory method لاستقبال arguments من pushNamed
  static Route route(RouteSettings settings) {
    final doctorId = settings.arguments as int;
    return MaterialPageRoute(
      builder: (_) => AppointmentScreen(doctorId: doctorId),
    );
  }
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime? _selected;
  final TextEditingController notesController = TextEditingController();
  bool _loading = false;

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;

    setState(() {
      _selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() async {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    setState(() => _loading = true);

    final formatted = DateFormat('yyyy-MM-dd HH:mm').format(_selected!);

    try {
      final res = await ApiService.instance.storeAppointment(
        doctorId: widget.doctorId,
        startTime: formatted,
        notes: notesController.text.trim(),
      );

      if (res['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment created')),
        );
        Navigator.pop(context);
      } else {
        final msg = res['message'] ?? (res['data']?.toString() ?? 'Failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedText = _selected == null
        ? 'No date chosen'
        : DateFormat('yyyy-MM-dd HH:mm').format(_selected!);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Selected: $selectedText'),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: const Text('Pick date & time'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
