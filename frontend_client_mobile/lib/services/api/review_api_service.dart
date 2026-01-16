import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/page_response.dart';
import 'package:frontend_client_mobile/models/review.dart';
import 'package:retrofit/retrofit.dart';

part 'review_api_service.g.dart';

@RestApi()
abstract class ReviewApiService {
  factory ReviewApiService(Dio dio, {String? baseUrl}) = _ReviewApiService;

  @POST("/api/reviews")
  Future<Review> createReview(
    @Query("userId") int userId,
    @Body() Map<String, dynamic> request,
  );

  @GET("/api/reviews/can-review/{orderItemId}")
  Future<HttpResponse<dynamic>> canReview(
    @Path("orderItemId") int orderItemId,
    @Query("userId") int userId,
  );

  @GET("/api/reviews/product/{productId}")
  Future<PageResponse<Review>> getProductReviews(
    @Path("productId") int productId,
    @Query("page") int page,
    @Query("size") int size,
  );

  @GET("/api/reviews/product/{productId}/summary")
  Future<ProductReviewSummary> getProductReviewSummary(
    @Path("productId") int productId,
  );

  @GET("/api/reviews/user")
  Future<PageResponse<Review>> getUserReviews(
    @Query("userId") int userId,
    @Query("page") int page,
    @Query("size") int size,
  );

  @GET("/api/reviews/order/{orderId}/reviewed-items")
  Future<HttpResponse<dynamic>> getReviewedOrderItemIds(
    @Path("orderId") int orderId,
  );
}
