class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? avatar; // صورة اختيارية

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      gender: json["gender"]?.toString() ?? "",
      avatar: json["avatar"] ?? json["image"], // نخليها null لو ما في صورة
    );
  }
}
