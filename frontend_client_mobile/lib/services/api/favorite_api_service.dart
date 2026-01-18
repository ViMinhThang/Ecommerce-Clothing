import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/wishlist_item.dart';
import 'package:retrofit/retrofit.dart';

part 'favorite_api_service.g.dart';

@RestApi()
abstract class FavoriteApiService {
  factory FavoriteApiService(Dio dio, {String? baseUrl}) = _FavoriteApiService;

  @GET("/api/favorites/user/{userId}")
  Future<List<WishlistItem>> getFavoritesByUserId(@Path("userId") int userId);

  @POST("/api/favorites/add")
  Future<WishlistItem> addToFavorites(@Body() Map<String, int> request);

  @DELETE("/api/favorites/user/{userId}/product/{productId}")
  Future<void> removeFromFavorites(
    @Path("userId") int userId,
    @Path("productId") int productId,
  );

  @GET("/api/favorites/user/{userId}/product/{productId}/check")
  Future<Map<String, bool>> isInFavorites(
    @Path("userId") int userId,
    @Path("productId") int productId,
  );
}
