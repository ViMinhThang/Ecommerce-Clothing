import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _keyAccess = 'ACCESS_TOKEN';
  static const _keyRefresh = 'REFRESH_TOKEN';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccess, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefresh, value: token);
  }

  Future<String?> readAccessToken() async {
    return await _storage.read(key: _keyAccess);
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: _keyRefresh);
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
  }
}
