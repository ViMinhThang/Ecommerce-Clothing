import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/wishlist_item.dart';
import 'package:retrofit/retrofit.dart';

part 'wishlist_api_service.g.dart';

@RestApi()
abstract class WishlistApiService {
  factory WishlistApiService(Dio dio, {String? baseUrl}) = _WishlistApiService;

  @GET("/api/wishlist/user/{userId}")
  Future<List<WishlistItem>> getWishlistByUserId(@Path("userId") int userId);

  @POST("/api/wishlist/add")
  Future<WishlistItem> addToWishlist(@Body() Map<String, int> request);

  @DELETE("/api/wishlist/user/{userId}/product/{productId}")
  Future<void> removeFromWishlist(
    @Path("userId") int userId,
    @Path("productId") int productId,
  );

  @GET("/api/wishlist/user/{userId}/product/{productId}/check")
  Future<Map<String, bool>> isInWishlist(
    @Path("userId") int userId,
    @Path("productId") int productId,
  );
}
