import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/category.dart';
import 'package:retrofit/retrofit.dart';

part 'category_api_service.g.dart';

@RestApi()
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio, {String? baseUrl}) = _CategoryApiService;

  @GET("api/categories")
  Future<List<Category>> getCategories(@Query("name") String? name);

  @POST("api/categories")
  Future<Category> createCategory(@Body() Category category);

  @PUT("api/categories/{id}")
  Future<Category> updateCategory(
    @Path("id") int id,
    @Body() Category category,
  );

  @DELETE("api/categories/{id}")
  Future<void> deleteCategory(@Path("id") int id);

  @MultiPart()
  @POST("api/categories/upload/category-image")
  Future<String> uploadCategoryImage(
    @Part(name: "image") MultipartFile imageFile,
  );
}
