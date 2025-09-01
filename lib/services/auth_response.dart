class AuthResponse {
  final String token;
  final String username;

  AuthResponse({
    required this.token,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // بعض الـ APIs ترجع البيانات بهذا الشكل:
    // { "data": { "token": "...", "user": { "name": "..." } } }
    final data = json["data"] ?? json;

    return AuthResponse(
      token: data["token"] ?? "",
      username: data["username"] ??
          data["name"] ??
          data["user"]?["name"] ??
          "",
    );
  }
}
