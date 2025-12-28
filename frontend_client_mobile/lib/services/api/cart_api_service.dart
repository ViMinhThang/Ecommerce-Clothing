import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/cart.dart';
import 'package:frontend_client_mobile/models/product_variant.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_service.g.dart';

@RestApi()
abstract class CartApiService {
  factory CartApiService(Dio dio, {String? baseUrl}) = _CartApiService;

  @POST("api/cart/add")
  Future<CartView> addToCart(@Body() AddToCartRequest request);

  @GET("api/cart/user/{userId}")
  Future<CartView> getCartByUserId(@Path("userId") int userId);

  @DELETE("api/cart/item/{cartItemId}")
  Future<void> removeFromCart(@Path("cartItemId") int cartItemId);

  @PUT("api/cart/item/{cartItemId}/quantity")
  Future<void> updateQuantity(
    @Path("cartItemId") int cartItemId,
    @Query("quantity") int quantity,
  );

  @DELETE("api/cart/user/{userId}/clear")
  Future<void> clearCart(@Path("userId") int userId);
}

@RestApi()
abstract class ProductVariantApiService {
  factory ProductVariantApiService(Dio dio, {String? baseUrl}) = _ProductVariantApiService;

  @GET("api/products/variants/{id}")
  Future<List<ProductVariant>> getProductVariants(@Path("id") int productId);
}
