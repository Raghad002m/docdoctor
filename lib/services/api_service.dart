import 'package:dio/dio.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';
import '../models/user_mode;.dart';
import 'auth_response.dart';
import 'package:intl/intl.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://vcare.integration25.com/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {"Accept": "application/json"},
    ),
  );

  String? _token;

  // ====== Token Setter & Getter ======
  void setToken(String token) {
    _token = token;
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  String? get token => _token;

  // ====== Auth ======
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
        options: Options(contentType: Headers.jsonContentType),
      );

      final token = res.data["data"]["token"];
      if (token != null) setToken(token);

      return AuthResponse.fromJson(res.data["data"]);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<String> register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final res = await _dio.post(
        "/auth/register",
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "gender": gender,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      final token = res.data["data"]?["token"];
      if (token != null) setToken(token);

      return res.data["message"] ?? "Registered successfully";
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post("/auth/logout");
      _token = null;
      _dio.options.headers.remove("Authorization");
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ====== User ======
  Future<User> getProfile() async {
    try {
      final res = await _dio.get("/user/profile");
      final data = res.data["data"];

      if (data is List && data.isNotEmpty) {
        return User.fromJson(data[0]);
      } else if (data is Map<String, dynamic>) {
        return User.fromJson(data);
      } else {
        throw Exception("Invalid user data format");
      }
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ====== Doctors ======
  Future<List<Doctor>> getDoctors() async {
    _checkAuth();

    try {
      final res = await _dio.get("/doctor/index");
      final List data = res.data["data"];
      return data.map((doc) => Doctor.fromJson(doc)).toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Doctor> getDoctor(int id) async {
    _checkAuth();

    try {
      final res = await _dio.get("/doctor/show/$id");
      return Doctor.fromJson(res.data["data"]);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ====== Search Doctor ======
  Future<List<Doctor>> searchDoctors(String name) async {
    _checkAuth();

    try {
      final res = await _dio.get(
        "/doctor/doctor-search",
        queryParameters: {"name": name},
      );
      final List data = res.data["data"];
      return data.map((doc) => Doctor.fromJson(doc)).toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ====== Filter Doctor ======
  Future<List<Doctor>> filterDoctors({
    int? cityId,
    int? specializationId,
  }) async {
    _checkAuth();

    try {
      final res = await _dio.get(
        "/doctor/doctor-filter",
        queryParameters: {
          if (cityId != null) "city": cityId,
          if (specializationId != null) "specialization": specializationId,
        },
      );

      final List data = res.data["data"];
      return data.map((doc) => Doctor.fromJson(doc)).toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

// ====== Get Doctors by Specialization Name ======
  Future<List<Doctor>> getDoctorsBySpecializationName(String name) async {
    _checkAuth();

    try {
      final res = await _dio.get(
        "/doctor/doctor-filter",
        queryParameters: {"specialization": name},
      );

      final List data = res.data["data"];
      return data.map((doc) => Doctor.fromJson(doc)).toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }



  // ====== Appointments ======
  Future<List<Appointment>> getAppointments() async {
    _checkAuth();

    try {
      final res = await _dio.get("/appointment/index");
      final List data = res.data["data"];
      return data.map((app) => Appointment.fromJson(app)).toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<String> createAppointment({
    required int doctorId,
    required DateTime startTime,
    String? notes,
  }) async {
    _checkAuth();

    try {
      final formattedTime = DateFormat("yyyy-MM-dd HH:mm").format(startTime);

      final formData = FormData.fromMap({
        "doctor_id": doctorId.toString(),
        "start_time": formattedTime,
        "notes": notes ?? "",
      });

      final res = await _dio.post(
        "/appointment/store",
        data: formData,
      );

      return res.data["message"] ?? "Appointment created";
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ====== Helpers ======
  void _checkAuth() {
    if (_token == null) {
      throw Exception("Unauthorized: Please login first");
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey("errors")) {
        final errors =
        (data["errors"] as Map).values.expand((v) => v).join("\n");
        return errors;
      }
      return data.toString();
    } else {
      return e.message ?? "Connection error";
    }
  }
}
