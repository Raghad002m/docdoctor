import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class YourSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "auth_token";

  // حفظ التوكن
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // جلب التوكن
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // مسح التوكن
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
