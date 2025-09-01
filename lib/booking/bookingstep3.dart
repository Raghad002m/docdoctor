import 'package:flutter/material.dart';

import '../services/api_service.dart';


class BookingFlow extends StatefulWidget {
  final int doctorId;
  final String doctorName;

  const BookingFlow({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<BookingFlow> createState() => _BookingFlowState();
}

class _BookingFlowState extends State<BookingFlow> {
  int currentStep = 0;
  DateTime? selectedDateTime;
  String? appointmentType;
  String? paymentMethod;
  bool isLoading = false;
  bool isConfirmed = false;

  final ApiService api = ApiService();

  Future<void> confirmBooking() async {
    if (selectedDateTime == null || appointmentType == null || paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date, type, and payment method")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final message = await api.createAppointment(
        doctorId: widget.doctorId,
        startTime: selectedDateTime!,
        notes: "$appointmentType - Paid via $paymentMethod",
      );

      setState(() {
        currentStep = 3;
        isConfirmed = true;
      });

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
      appBar: AppBar(title: Text("Book with ${widget.doctorName}")),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 2) {
            setState(() => currentStep += 1);
          } else {
            confirmBooking();
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: const Text("Choose Date & Time"),
            content: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          selectedDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  child: const Text("Select Date & Time"),
                ),
                if (selectedDateTime != null)
                  Text("Selected: $selectedDateTime"),
              ],
            ),
          ),
          Step(
            title: const Text("Appointment Type"),
            content: Column(
              children: [
                RadioListTile(
                  title: const Text("In-person"),
                  value: "In-person",
                  groupValue: appointmentType,
                  onChanged: (val) => setState(() => appointmentType = val),
                ),
                RadioListTile(
                  title: const Text("Online"),
                  value: "Online",
                  groupValue: appointmentType,
                  onChanged: (val) => setState(() => appointmentType = val),
                ),
              ],
            ),
          ),
          Step(
            title: const Text("Payment"),
            content: Column(
              children: [
                RadioListTile(
                  title: const Text("Cash"),
                  value: "Cash",
                  groupValue: paymentMethod,
                  onChanged: (val) => setState(() => paymentMethod = val),
                ),
                RadioListTile(
                  title: const Text("Credit Card"),
                  value: "Credit Card",
                  groupValue: paymentMethod,
                  onChanged: (val) => setState(() => paymentMethod = val),
                ),
              ],
            ),
          ),
          Step(
            title: const Text("Confirmation"),
            content: isLoading
                ? const CircularProgressIndicator()
                : isConfirmed
                ? Column(
              children: [
                const Text(
                  "🎉 Your booking is confirmed!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text("Back to Home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            )
                : const Text("Complete your booking."),
          ),
        ],
      ),
    );
  }
}
