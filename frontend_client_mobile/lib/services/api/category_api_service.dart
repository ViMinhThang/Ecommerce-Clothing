import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/category.dart';
import 'package:retrofit/retrofit.dart';

part 'category_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/")
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio, {String baseUrl}) = _CategoryApiService;

  @GET("api/categories")
  Future<List<Category>> getCategories();
}
