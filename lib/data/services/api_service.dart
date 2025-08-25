// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = 'https://vcare.integration25.com/api'; // من Postman. :contentReference[oaicite:1]{index=1}

  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService._internal()
      : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {'Accept': 'application/json'},
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  )) {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _storage.read(key: 'token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }, onError: (err, handler) {
      return handler.next(err);
    }, onResponse: (res, handler) {
      return handler.next(res);
    }));
  }

  static final ApiService instance = ApiService._internal();

  // ---------------- Token helpers ----------------
  Future<void> saveToken(String token) async => await _storage.write(key: 'token', value: token);
  Future<String?> getToken() async => await _storage.read(key: 'token');
  Future<void> deleteToken() async => await _storage.delete(key: 'token');

  // ---------------- Generic error wrapper ----------------
  String _extractMessage(Response r) {
    try {
      if (r.data is Map && r.data['message'] != null) return r.data['message'].toString();
      if (r.data is Map && r.data['data'] != null) return r.data['data'].toString();
    } catch (e) {}
    return 'Unknown error';
  }

  // ---------------- Auth ----------------
  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await _dio.post('/auth/login', data: FormData.fromMap({
      'email': email,
      'password': password,
    }));
    final Map<String, dynamic> data = Map<String, dynamic>.from(resp.data);
    if (data['status'] == true && data['data'] != null && data['data']['token'] != null) {
      await saveToken(data['data']['token']);
    }
    return data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    final resp = await _dio.post('/auth/register', data: FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'password': password,
      'password_confirmation': passwordConfirmation,
    }));
    return Map<String, dynamic>.from(resp.data);
  }

  Future<Map<String, dynamic>> logout() async {
    final resp = await _dio.post('/auth/logout');
    await deleteToken();
    return Map<String, dynamic>.from(resp.data);
  }

  // ---------------- User ----------------
  Future<Map<String, dynamic>> getProfile() async {
    final resp = await _dio.get('/user/profile');
    return Map<String, dynamic>.from(resp.data);
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? password,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;
    if (gender != null) body['gender'] = gender;
    if (password != null) body['password'] = password;
    final resp = await _dio.post('/user/update', data: FormData.fromMap(body));
    return Map<String, dynamic>.from(resp.data);
  }

  // ---------------- Static data ----------------
  Future<List<dynamic>> getGovernrates() async {
    final resp = await _dio.get('/governrate/index'); // من الملف. :contentReference[oaicite:2]{index=2}
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<List<dynamic>> getCities() async {
    final resp = await _dio.get('/city/index');
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<List<dynamic>> getCitiesByGov(int govId) async {
    final resp = await _dio.get('/city/show/$govId'); // مثال: /city/show/7. :contentReference[oaicite:3]{index=3}
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<List<dynamic>> getSpecializations() async {
    final resp = await _dio.get('/specialization/index'); // :contentReference[oaicite:4]{index=4}
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getSpecializationById(int id) async {
    final resp = await _dio.get('/specialization/show/$id');
    return Map<String, dynamic>.from(resp.data);
  }

  // ---------------- Doctors ----------------
  Future<List<dynamic>> getDoctors() async {
    final resp = await _dio.get('/doctor/index'); // :contentReference[oaicite:5]{index=5}
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getDoctorById(int id) async {
    final resp = await _dio.get('/doctor/show/$id'); // :contentReference[oaicite:6]{index=6}
    return Map<String, dynamic>.from(resp.data);
  }

  Future<List<dynamic>> filterDoctors({required int cityId}) async {
    final resp = await _dio.get('/doctor/doctor-filter', queryParameters: {'city': cityId});
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<List<dynamic>> searchDoctors({required String name}) async {
    final resp = await _dio.get('/doctor/doctor-search', queryParameters: {'name': name});
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  // ---------------- Appointments ----------------
  Future<List<dynamic>> getAppointments() async {
    final resp = await _dio.get('/appointment/index');
    return (resp.data['data'] ?? []) as List<dynamic>;
  }

  Future<Map<String, dynamic>> storeAppointment({
    required int doctorId,
    required String startTime, // format: "YYYY-MM-DD HH:MM"
    String? notes,
  }) async {
    final resp = await _dio.post('/appointment/store', data: FormData.fromMap({
      'doctor_id': doctorId.toString(),
      'start_time': startTime,
      'notes': notes ?? '',
    }));
    return Map<String, dynamic>.from(resp.data);
  }
}
