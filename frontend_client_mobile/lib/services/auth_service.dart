import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';
import 'package:frontend_client_mobile/services/api/api_config.dart';

class AuthService {
  final Dio _dio;
  final TokenStorage _storage = TokenStorage();

  AuthService({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final res = await _dio.post(
      '/api/auth/login',
      data: {'username': username, 'password': password},
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = res.data;
      final access =
          data['accessToken'] ?? data['access_token'] ?? data['token'];
      final refresh = data['refreshToken'] ?? data['refresh_token'];
      if (access == null) throw Exception('No access token returned');
      await _storage.saveAccessToken(access.toString());
      if (refresh != null) await _storage.saveRefreshToken(refresh.toString());
    } else {
      throw Exception('Login failed');
    }
  }

  Future<bool> refreshToken() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh == null) return false;
    try {
      final res = await _dio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refresh},
      );
      if (res.statusCode == 200) {
        final data = res.data;
        final access =
            data['accessToken'] ?? data['access_token'] ?? data['token'];
        final newRefresh = data['refreshToken'] ?? data['refresh_token'];
        if (access == null) return false;
        await _storage.saveAccessToken(access.toString());
        if (newRefresh != null)
          await _storage.saveRefreshToken(newRefresh.toString());
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> logout() async {
    await _storage.clear();
  }
}
