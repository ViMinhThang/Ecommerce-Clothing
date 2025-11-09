import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/user.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/")
abstract class UserApiService {
  factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

  @GET("api/users/{id}")
  Future<User> getUser(@Path("id") int id);

  @PUT("api/users/{id}")
  Future<User> updateUser(
    @Path("id") int id,
    @Body() User user,
  );

  @POST("api/users/{id}/avatar")
  @MultiPart()
  Future<User> uploadAvatar(
    @Path("id") int id,
    @Part(name: "avatar") File avatar,
  );
}

