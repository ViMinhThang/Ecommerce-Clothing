import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/auth_api_service.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';

class AuthService {
  final AuthApiService _apiService;
  final TokenStorage _storage = TokenStorage();

  AuthService({AuthApiService? apiService})
    : _apiService = apiService ?? ApiClient.getAuthApiService();

  Future<List<String>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiService.login({
        'username': username,
        'password': password,
      });

      final res = response.response;
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        final access =
            data['accessToken'] ?? data['access_token'] ?? data['token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'];
        final roles = data['roles'] as List<dynamic>? ?? [];
        final userId = data['id'] ?? data['userId'] ?? data['user_id'];

        if (access == null) throw Exception('No access token returned');

        await _storage.saveAccessToken(access.toString());
        if (refresh != null) {
          await _storage.saveRefreshToken(refresh.toString());
        }
        
        final rolesList = roles.map((r) => r.toString()).toList();
        await _storage.saveRoles(rolesList);
        
        if (userId != null) {
          await _storage.saveUserId(int.tryParse(userId.toString()) ?? 0);
        }
        
        return rolesList;
      } else {
        throw Exception('Login failed with status: ${res.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Connection error';
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data is Map && data.containsKey('error')) {
          errorMessage = data['error'];
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
      } else {
        errorMessage = 'Network error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<bool> refreshToken() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await _apiService.refresh({'refreshToken': refresh});
      final res = response.response;

      if (res.statusCode == 200) {
        final data = res.data;
        final access =
            data['accessToken'] ?? data['access_token'] ?? data['token'];
        final newRefresh = data['refreshToken'] ?? data['refresh_token'];

        if (access == null) return false;

        await _storage.saveAccessToken(access.toString());
        if (newRefresh != null) {
          await _storage.saveRefreshToken(newRefresh.toString());
        }
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> logout() async {
    await _storage.clear();
  }
}
