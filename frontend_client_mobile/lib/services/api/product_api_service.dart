import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/product.dart';
import 'package:retrofit/retrofit.dart';

part 'product_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/")
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String baseUrl}) = _ProductApiService;

  @GET("api/products")
  Future<HttpResponse<PageResponse<Product>>> getProducts(
    @Query("name") String? name,
    @Query("page") int page,
    @Query("size") int size,
  );

  @GET("api/products/{id}")
  Future<Product> getProduct(@Path("id") int id);

  @POST("api/products")
  @MultiPart()
  Future<Product> createProduct(
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "categoryId") int categoryId,
    @Part(name: "variants") String variants,
    @Part(name: "image") File? image,
  );

  @PUT("api/products/{id}")
  @MultiPart()
  Future<Product> updateProduct(
    @Path("id") int id,
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "categoryId") int categoryId,
    @Part(name: "variants") String variants,
    @Part(name: "image") File? image,
  );

  @DELETE("api/products/{id}")
  Future<void> deleteProduct(@Path("id") int id);
}
