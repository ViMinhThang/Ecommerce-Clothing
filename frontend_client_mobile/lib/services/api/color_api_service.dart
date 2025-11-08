import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/color.dart';
import 'package:retrofit/retrofit.dart';

part 'color_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/")
abstract class ColorApiService {
  factory ColorApiService(Dio dio, {String baseUrl}) = _ColorApiService;

  @GET("api/colors")
  Future<List<Color>> getColors();
}
