import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST("/api/auth/login")
  Future<HttpResponse> login(@Body() Map<String, dynamic> body);

  @POST("/api/auth/refresh")
  Future<HttpResponse> refresh(@Body() Map<String, dynamic> body);
}
