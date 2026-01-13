import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/user_detail_view.dart';
import 'package:frontend_client_mobile/models/user_item_view.dart';
import 'package:frontend_client_mobile/models/user_request.dart';
import 'package:frontend_client_mobile/models/user_search_result.dart';
import 'package:frontend_client_mobile/models/user_update_request.dart';
import 'dart:io';
import 'package:frontend_client_mobile/models/user.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/user_api_service.dart';

class UserService {
  UserService({UserApiService? api})
    : _api = api ?? ApiClient.getUserApiService();

  final UserApiService _api;

  Future<PageResponse<UserItemView>> fetchUsers({
    int page = 0,
    int size = 10,
    String sort = 'createdDate,desc',
  }) async {
    final response = await _api.getUsers(page, size, sort);
    return response.data;
  }

  Future<UserDetailView> getUserDetail(int id) => _api.getUserDetail(id);

  Future<UserUpdateRequest> getUserUpdateInfo(int id) =>
      _api.getUserUpdateInfo(id);

  Future<List<UserSearchResult>> searchUsers(String keyword) {
    if (keyword.trim().isEmpty) {
      return Future.value(const []);
    }
    return _api.searchUsers(keyword.trim());
  }

  Future<void> createUser(UserRequest request) => _api.createUser(request);

  Future<void> updateUser(int id, UserUpdateRequest request) =>
      _api.updateUser(id, request);

  Future<void> deleteUser(int id) => _api.deleteUser(id);

  // Merged methods from conflict section (Using _api instead of _apiService)

  Future<User> getUser(int id) async {
    return await _api.getUser(id);
  }

  Future<User> updateUserAvatar(int id, UserUpdateRequest request) async {
    await _api.updateUser(id, request);
    // Return the updated user
    return await _api.getUser(id);
  }

  Future<User> uploadAvatar(int id, File avatar) async {
    return await _api.uploadAvatar(id, avatar);
  }

  // New methods for current user profile
  Future<UserDetailView> getCurrentUserProfile(int userId) =>
      _api.getCurrentUserProfile(userId);

  Future<void> updateCurrentUserProfile(
    int userId,
    UserUpdateRequest request,
  ) => _api.updateCurrentUserProfile(userId, request);
}
