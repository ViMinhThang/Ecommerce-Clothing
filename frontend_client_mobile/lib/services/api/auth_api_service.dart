import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/auth_response.dart';
import 'package:frontend_client_mobile/models/login_request.dart';
import 'package:frontend_client_mobile/models/register_request.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST('/api/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/api/auth/register')
  Future<HttpResponse<String>> register(@Body() RegisterRequest request);

  @GET('/api/auth/validate')
  Future<String> validateToken();
}
