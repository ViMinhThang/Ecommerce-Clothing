import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_service.g.dart';

@RestApi()
abstract class CartApiService {
  factory CartApiService(Dio dio, {String? baseUrl}) = _CartApiService;

  @GET("api/cart")
  Future<HttpResponse> getCart();

  @POST("api/cart/items")
  Future<HttpResponse> addToCart(@Body() Map<String, dynamic> item);

  @DELETE("api/cart/items/{id}")
  Future<HttpResponse> removeFromCart(@Path("id") int id);

  @PUT("api/cart/items/{id}")
  Future<HttpResponse> updateCartItem(
    @Path("id") int id,
    @Body() Map<String, dynamic> item,
  );

  @DELETE("api/cart")
  Future<HttpResponse> clearCart();
}
