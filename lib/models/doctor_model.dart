class DoctorModel {
  final int id;
  final String name;
  final String specialization;
  final String phone;
  final String? image;
  final double? rating;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.phone,
    this.image,
    this.rating,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'phone': phone,
    'image': image,
    'rating': rating,
  };
}
