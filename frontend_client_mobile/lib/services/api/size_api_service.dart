import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:retrofit/retrofit.dart';

part 'size_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/")
abstract class SizeApiService {
  factory SizeApiService(Dio dio, {String baseUrl}) = _SizeApiService;

  @GET("api/sizes")
  Future<List<Size>> getSizes();
}
