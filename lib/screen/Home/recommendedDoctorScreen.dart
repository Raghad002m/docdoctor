import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/doctor_model.dart';
import '../../services/api_service.dart';

class RecommendedDoctorScreen extends StatefulWidget {
  const RecommendedDoctorScreen({super.key});

  @override
  State<RecommendedDoctorScreen> createState() => _RecommendedDoctorScreenState();
}

class _RecommendedDoctorScreenState extends State<RecommendedDoctorScreen> {
  final api = ApiService();
  Future<List<Doctor>>? _futureDoctors;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  // ✅ تحميل التوكن أولاً ثم جلب قائمة الأطباء
  Future<void> _loadDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && savedToken.isNotEmpty) {
      api.setToken(savedToken);
      setState(() {
        _futureDoctors = api.getDoctors();
      });
    } else {
      setState(() {
        _futureDoctors = Future.error("Unauthorized: Please login first");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommended Doctors"),
        centerTitle: true,
      ),
      body: _futureDoctors == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No doctors found"));
          }

          final doctors = snapshot.data!;
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: doctor.image != null && doctor.image!.isNotEmpty
                        ? NetworkImage(doctor.image!)
                        : const AssetImage("assets/images/default_doctor.png") as ImageProvider,
                  ),
                  title: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(doctor.specialization),
                  trailing: doctor.rating != null
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(doctor.rating!.toString()),
                    ],
                  )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingFlow(doctorId: doctor.id, doctorName: '',),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BookingFlow extends StatefulWidget {
  final int doctorId;
  final String doctorName;

  const BookingFlow({super.key, required this.doctorId, required this.doctorName});

  @override
  State<BookingFlow> createState() => _BookingFlowState();
}

class _BookingFlowState extends State<BookingFlow> {
  final api = ApiService();

  int currentStep = 0;

  DateTime? selectedDateTime;
  String? appointmentType;
  String? paymentMethod;

  bool isLoading = false;

  void nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  Future<void> confirmBooking() async {
    if (selectedDateTime == null || appointmentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date, time and type")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final message = await api.createAppointment(
        doctorId: widget.doctorId,
        startTime: selectedDateTime!,
        notes: appointmentType,
      );

      setState(() => currentStep = 3);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep == 2) {
            confirmBooking();
          } else {
            nextStep();
          }
        },
        onStepCancel: previousStep,
        controlsBuilder: (context, details) {
          return currentStep == 3
              ? const SizedBox.shrink()
              : Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: currentStep == 2
                    ? (isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Book Now"))
                    : const Text("Continue"),
              ),
              const SizedBox(width: 10),
              if (currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text("Back"),
                ),
            ],
          );
        },
        steps: [
          // Step 1: Date & Time + Type
          Step(
            title: const Text("Date & Time"),
            isActive: currentStep >= 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date == null) return;

                    final time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (time == null) return;

                    setState(() {
                      selectedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  },
                  child: Text(
                    selectedDateTime == null
                        ? "Select Date & Time"
                        : DateFormat("yyyy-MM-dd HH:mm")
                        .format(selectedDateTime!),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Appointment Type"),
                Column(
                  children: [
                    RadioListTile(
                      title: const Text("In Person"),
                      value: "In Person",
                      groupValue: appointmentType,
                      onChanged: (val) =>
                          setState(() => appointmentType = val),
                    ),
                    RadioListTile(
                      title: const Text("Video Call"),
                      value: "Video Call",
                      groupValue: appointmentType,
                      onChanged: (val) =>
                          setState(() => appointmentType = val),
                    ),
                    RadioListTile(
                      title: const Text("Phone Call"),
                      value: "Phone Call",
                      groupValue: appointmentType,
                      onChanged: (val) =>
                          setState(() => appointmentType = val),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Step 2: Payment
          Step(
            title: const Text("Payment"),
            isActive: currentStep >= 1,
            content: Column(
              children: [
                RadioListTile(
                  title: const Text("Credit Card"),
                  value: "Credit Card",
                  groupValue: paymentMethod,
                  onChanged: (val) => setState(() => paymentMethod = val),
                ),
                RadioListTile(
                  title: const Text("PayPal"),
                  value: "PayPal",
                  groupValue: paymentMethod,
                  onChanged: (val) => setState(() => paymentMethod = val),
                ),
                RadioListTile(
                  title: const Text("Bank Transfer"),
                  value: "Bank Transfer",
                  groupValue: paymentMethod,
                  onChanged: (val) => setState(() => paymentMethod = val),
                ),
              ],
            ),
          ),

          // Step 3: Review
          Step(
            title: const Text("Summary"),
            isActive: currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Doctor: ${widget.doctorName}"),
                Text("Date & Time: ${selectedDateTime != null ? DateFormat("yyyy-MM-dd HH:mm").format(selectedDateTime!) : "-"}"),
                Text("Type: ${appointmentType ?? "-"}"),
                Text("Payment: ${paymentMethod ?? "-"}"),
              ],
            ),
          ),

          // Step 4: Confirmation
          Step(
            title: const Text("Confirmation"),
            isActive: currentStep >= 3,
            state: StepState.complete,
            content: Column(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                SizedBox(height: 10),
                Text("Booking Confirmed!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
