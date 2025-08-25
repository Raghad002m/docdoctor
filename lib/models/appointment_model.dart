class AppointmentModel {
  final int id;
  final int doctorId;
  final String startTime;
  final String status;
  final String? notes;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.startTime,
    required this.status,
    this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : int.parse(json['doctor_id'].toString()),
      startTime: json['start_time'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
    );
  }
}
