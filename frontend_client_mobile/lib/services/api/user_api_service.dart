import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/page_response.dart';
import 'package:frontend_client_mobile/models/user_detail_view.dart';
import 'package:frontend_client_mobile/models/user_item_view.dart';
import 'package:frontend_client_mobile/models/user_request.dart';
import 'package:frontend_client_mobile/models/user_update_request.dart';
import 'package:frontend_client_mobile/models/user_search_result.dart';
import 'package:frontend_client_mobile/models/user.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) = _UserApiService;

  @GET('/api/users')
  Future<HttpResponse<PageResponse<UserItemView>>> getUsers(
    @Query('page') int page,
    @Query('size') int size,
    @Query('sort') String sort,
  );

  @GET('/api/users/detail/{id}')
  Future<UserDetailView> getUserDetail(@Path('id') int id);

  @GET('/api/users/update/{id}')
  Future<UserUpdateRequest> getUserUpdateInfo(@Path('id') int id);

  @GET('/api/users/search')
  Future<List<UserSearchResult>> searchUsers(@Query('name') String keyword);

  @POST('/api/users')
  Future<void> createUser(@Body() UserRequest request);

  @PUT('/api/users/{id}')
  Future<void> updateUser(
    @Path('id') int id,
    @Body() UserUpdateRequest request,
  );

  @DELETE('/api/users/{id}')
  Future<void> deleteUser(@Path('id') int id);

  @GET('/api/users/{id}')
  Future<User> getUser(@Path('id') int id);

  @POST('/api/users/{id}/avatar')
  @MultiPart()
  Future<User> uploadAvatar(
    @Path('id') int id,
    @Part(name: 'avatar') File avatar,
  );

  // New endpoints for current user profile
  @GET('/api/users/me')
  Future<UserDetailView> getCurrentUserProfile(@Query('userId') int userId);

  @PUT('/api/users/me')
  Future<void> updateCurrentUserProfile(
    @Query('userId') int userId,
    @Body() UserUpdateRequest request,
  );
}
