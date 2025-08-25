class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? gender;
  final String? avatar; // لو في

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'gender': gender,
    'avatar': avatar,
  };
}
