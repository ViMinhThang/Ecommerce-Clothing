import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:retrofit/retrofit.dart';

part 'size_api_service.g.dart';

@RestApi()
abstract class SizeApiService {
  factory SizeApiService(Dio dio, {String? baseUrl}) = _SizeApiService;

  @GET("api/sizes")
  Future<HttpResponse<PageResponse<Size>>> getSizes(
    @Query("page") int page,
    @Query("size") int size,
  );

  @POST("api/sizes")
  Future<Size> createSize(@Body() Size size);

  @PUT("api/sizes/{id}")
  Future<Size> updateSize(@Path("id") int id, @Body() Size size);

  @DELETE("api/sizes/{id}")
  Future<void> deleteSize(@Path("id") int id);
}
