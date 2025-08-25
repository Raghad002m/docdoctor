import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/TokenStorage.dart';


class AuthService {
  static const String baseUrl = "https://example.com/api"; // عدل الرابط

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse("$baseUrl/auth/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "password": password,
        "password_confirmation": passwordConfirmation,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['data']?['token'] as String?;
      if (token != null) {
        await TokenStorage.save(token);
      }
      return token;
    } else {
      throw Exception('Register failed: ${response.body}');
    }
  }

  Future<String> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['data']?['token'] as String?;
      if (token == null) throw Exception("Token not found");
      await TokenStorage.save(token);
      return token;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    final token = await TokenStorage.read();
    final url = Uri.parse("$baseUrl/auth/logout");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      await TokenStorage.clear();
    } else {
      throw Exception('Logout failed: ${response.body}');
    }
  }
}
