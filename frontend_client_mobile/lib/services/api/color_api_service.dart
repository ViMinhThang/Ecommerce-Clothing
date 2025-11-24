import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:retrofit/retrofit.dart';

part 'color_api_service.g.dart';

@RestApi()
abstract class ColorApiService {
  factory ColorApiService(Dio dio, {String? baseUrl}) = _ColorApiService;

  @GET("api/colors")
  Future<HttpResponse<PageResponse<Color>>> getColors(
    @Query("page") int page,
    @Query("size") int size,
  );

  @POST("api/colors")
  Future<Color> createColor(@Body() Color color);

  @PUT("api/colors/{id}")
  Future<Color> updateColor(@Path("id") int id, @Body() Color color);

  @DELETE("api/colors/{id}")
  Future<void> deleteColor(@Path("id") int id);
}
