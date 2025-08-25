import 'package:api_request/api_request.dart';
import 'TokenStorage.dart';


/// Base URL (من Postman collection)
const String kBaseUrl = "https://vcare.integration25.com/api";

/// Default header (مطلوب من السيرفر)
const String kAcceptJson = "application/json";

/// مفتاح التوكن (ممكن تحفظه في secure storage / shared prefs)
const String kAuthHeader = "Authorization";

class ApiConfig {
  static void init() {
    ApiRequestOptions.instance?.config(
      baseUrl: kBaseUrl,
      tokenType: ApiRequestOptions.bearer,
      getAsyncToken: () async => await TokenStorage.read(),
      defaultHeaders: {
        "Accept": kAcceptJson,
      },
      logLevel: ApiLogLevel.info,
      connectTimeout: const Duration(seconds: 20),
    );
  }

  static Future<void> attachToken(String token) async {
    await TokenStorage.save(token);
  }

  static Future<void> clearToken() async {
    await TokenStorage.clear();
  }
}
