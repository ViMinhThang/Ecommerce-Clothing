import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/login_request.dart';
import 'package:frontend_client_mobile/models/register_request.dart';
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
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        // Handle authentication errors with helpful message
        if (statusCode == 401 || statusCode == 403) {
          errorMessage = 'Incorrect username or password!\n\nAvailable accounts:\n• sys.admin / 123456\n• john_doe / password';
        } else if (data is Map && data.containsKey('message')) {
          final message = data['message'].toString();
          if (message.toLowerCase().contains('bad credentials')) {
            errorMessage = 'Incorrect username or password!\n\nAvailable accounts:\n• sys.admin / 123456\n• john_doe / password';
          } else {
            errorMessage = message;
          }
        } else if (data is Map && data.containsKey('error')) {
          errorMessage = data['error'];
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
      } else {
        errorMessage = 'Network error: Unable to connect to server';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      final response = await _apiService.register(request);
      return response.data;
    } on DioException catch (e) {
      String errorMessage = 'Connection error';
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data is Map && data.containsKey('error')) {
          errorMessage = data['error'];
        } else if (data is String) {
          errorMessage = data;
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
