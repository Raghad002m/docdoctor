import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// رابط الـ API الأساسي (عدله حسب السيرفر تبعك)
const String baseUrl = "https://vcare.integration25.com/api";


class AuthApi {
  /// -------- REGISTER --------
  static Future<http.Response> register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse("$baseUrl/auth/register");

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "password": password,
        "password_confirmation": passwordConfirmation,
      }),
    );
  }

  /// -------- LOGIN --------
  static Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login");

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
  }

  /// -------- LOGOUT --------
  static Future<http.Response> logout({
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/auth/logout");

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }
}
