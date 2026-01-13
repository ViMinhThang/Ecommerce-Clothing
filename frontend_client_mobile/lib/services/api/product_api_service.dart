import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/product.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:retrofit/retrofit.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String? baseUrl}) = _ProductApiService;

  @GET("api/products")
  Future<HttpResponse<PageResponse<Product>>> getProducts(
    @Query("name") String? name,
    @Query("page") int page,
    @Query("size") int size,
  );

  @GET("api/products/{id}")
  Future<Product> getProduct(@Path("id") int id);

  @GET("api/products/getSimilar/{id}")
  Future<List<ProductView>> getSimilarProduct(@Path("id") int id);

  @POST("api/products")
  @MultiPart()
  Future<Product> createProduct(
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "categoryId") int categoryId,
    @Part(name: "variants") String variants,
    @Part(name: "images") List<MultipartFile> images,
  );

  @PUT("api/products/{id}")
  @MultiPart()
  Future<Product> updateProduct(
    @Path("id") int id,
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "categoryId") int categoryId,
    @Part(name: "variants") String variants,
    @Part(name: "images") List<MultipartFile> images,
    @Part(name: "existingImageIds") List<String> existingImageIds,
  );

  @DELETE("api/products/{id}")
  Future<void> deleteProduct(@Path("id") int id);

  @GET("api/products/{categoryId}/{pageIndex}/{pageSize}")
  Future<HttpResponse<PageResponse<ProductView>>> getProductsByCategory(
    @Path("categoryId") int categoryId,
    @Path("pageIndex") int pageIndex,
    @Path("pageSize") int pageSize,
  );
}
