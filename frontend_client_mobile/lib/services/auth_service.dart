import 'package:frontend_client_mobile/models/auth_response.dart';
import 'package:frontend_client_mobile/models/login_request.dart';
import 'package:frontend_client_mobile/models/register_request.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService({AuthApiService? api})
    : _api = api ?? ApiClient.getAuthApiService();

  final AuthApiService _api;
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  Future<AuthResponse> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final response = await _api.login(request);

    // Save token and user info
    await saveToken(response.token);
    await saveUserId(response.id);
    await saveUsername(response.username);

    return response;
  }

  Future<String> register(RegisterRequest request) async {
    final response = await _api.register(request);
    return response.data;
  }

  Future<bool> validateToken() async {
    try {
      await _api.validateToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
  }
}
