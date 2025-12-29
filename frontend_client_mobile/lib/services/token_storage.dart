import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _keyAccess = 'ACCESS_TOKEN';
  static const _keyRefresh = 'REFRESH_TOKEN';

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

  Future<void> clear() async {
    try {
      await _storage.delete(key: _keyAccess);
      await _storage.delete(key: _keyRefresh);
    } catch (_) {}
  }
}
