class Doctor {
  final int id;
  final String name;
  final String specialization;
  final String? hospital;
  final String? image;
  final double? rating;
  final String? description;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    this.hospital,
    this.image,
    this.rating,
    this.description,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // معالجة الصورة سواء كانت رابط كامل أو مجرد path
    String? imageUrl;
    if (json["image"] != null && json["image"].toString().isNotEmpty) {
      imageUrl = json["image"].toString().startsWith("http")
          ? json["image"]
          : "https://vcare.integration25.com/${json["image"]}";
    }

    // جلب الاسم سواء كان مباشرة أو داخل user
    String doctorName = '';
    if (json['name'] != null) {
      doctorName = json['name'];
    } else if (json['user'] != null && json['user']['name'] != null) {
      doctorName = json['user']['name'];
    } else if (json['doctor_name'] != null) {
      doctorName = json['doctor_name'];
    }

    return Doctor(
      id: json['id'] ?? 0,
      name: doctorName,
      specialization: json['specialization'] is Map
          ? json['specialization']['name'] ?? ''
          : (json['specialization'] ?? ''),
      hospital: json['hospital'] is Map
          ? json['hospital']['name'] ?? ''
          : (json['hospital'] ?? ''),
      image: imageUrl,
      rating: (json['rating'] != null)
          ? double.tryParse(json['rating'].toString())
          : null,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "specialization": specialization,
      "hospital": hospital,
      "image": image,
      "rating": rating,
      "description": description,
    };
  }
}
