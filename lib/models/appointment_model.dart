class Appointment {
  final int id;
  final int doctorId;
  final String startTime;
  final String notes;
  final String type; // New (In Person, Video Call, Phone Call)

  Appointment({
    required this.id,
    required this.doctorId,
    required this.startTime,
    required this.notes,
    required this.type,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json["id"] ?? 0,
      doctorId: json["doctor_id"] ?? 0,
      startTime: json["start_time"] ?? "",
      notes: json["notes"] ?? "",
      type: json["type"] ?? "In Person", // Default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctor_id": doctorId,
      "start_time": startTime,
      "notes": notes,
      "type": type,
    };
  }
}