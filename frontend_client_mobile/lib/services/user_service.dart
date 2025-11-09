import 'dart:io';
import 'package:frontend_client_mobile/models/user.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/user_api_service.dart';

class UserService {
  final UserApiService _apiService = ApiClient.getUserApiService();

  Future<User> getUser(int id) async {
    return await _apiService.getUser(id);
  }

  Future<User> updateUser(int id, User user) async {
    return await _apiService.updateUser(id, user);
  }

  Future<User> uploadAvatar(int id, File avatar) async {
    return await _apiService.uploadAvatar(id, avatar);
  }
}

