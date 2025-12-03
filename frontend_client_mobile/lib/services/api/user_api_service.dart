import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/user_detail_view.dart';
import 'package:frontend_client_mobile/models/user_item_view.dart';
import 'package:frontend_client_mobile/models/user_request.dart';
import 'package:frontend_client_mobile/models/user_update_request.dart';
import 'package:frontend_client_mobile/models/user_search_result.dart';
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
}
