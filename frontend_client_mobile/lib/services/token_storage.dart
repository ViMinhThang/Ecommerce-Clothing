import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _keyAccess = 'ACCESS_TOKEN';
  static const _keyRefresh = 'REFRESH_TOKEN';
  static const _keyRoles = 'USER_ROLES';
  static const _keyUserId = 'USER_ID';
  static const _keyUserName = 'USER_NAME';

  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _keyAccess, value: token);
    } catch (_) {}
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefresh, value: token);
    } catch (_) {}
  }

  Future<void> saveRoles(List<String> roles) async {
    try {
      await _storage.write(key: _keyRoles, value: jsonEncode(roles));
    } catch (_) {}
  }

  Future<void> saveUserId(int userId) async {
    try {
      await _storage.write(key: _keyUserId, value: userId.toString());
    } catch (_) {}
  }

  Future<void> saveUserName(String name) async {
    try {
      await _storage.write(key: _keyUserName, value: name);
    } catch (_) {}
  }

  Future<String?> readAccessToken() async {
    try {
      return await _storage.read(key: _keyAccess);
    } catch (_) {
      return null;
    }
  }

  Future<String?> readRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefresh);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> readRoles() async {
    try {
      final rolesJson = await _storage.read(key: _keyRoles);
      if (rolesJson != null) {
        final decoded = jsonDecode(rolesJson) as List<dynamic>;
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<int?> readUserId() async {
    try {
      final userIdStr = await _storage.read(key: _keyUserId);
      if (userIdStr != null) {
        return int.tryParse(userIdStr);
      }
    } catch (_) {}
    return null;
  }

  Future<String?> readUserName() async {
    try {
      return await _storage.read(key: _keyUserName);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> isAdmin() async {
    final roles = await readRoles();
    return roles.contains('ROLE_ADMIN');
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _keyAccess);
      await _storage.delete(key: _keyRefresh);
      await _storage.delete(key: _keyRoles);
      await _storage.delete(key: _keyUserId);
      await _storage.delete(key: _keyUserName);
    } catch (_) {}
  }
}
