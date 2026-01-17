import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/login_request.dart';
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
      final request = LoginRequest(
        username: username,
        password: password,
      );

      final response = await _apiService.login(request);

      final access = response.token;
      final roles = response.roles;
      final userId = response.id;

      await _storage.saveAccessToken(access);
      await _storage.saveRoles(roles);
      await _storage.saveUserId(userId);
      await _storage.saveUserName(username);

      return roles;
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

    // Refresh token is not implemented in the API yet
    // You can implement it later when the backend supports it
    return false;
  }

  Future<void> logout() async {
    await _storage.clear();
  }
}
