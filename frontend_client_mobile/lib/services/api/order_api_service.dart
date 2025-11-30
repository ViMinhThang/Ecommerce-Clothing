import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/order_statistics.dart';
import 'package:frontend_client_mobile/models/order_view.dart';
import 'package:retrofit/retrofit.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio, {String? baseUrl}) = _OrderApiService;

  @GET("/api/orders")
  Future<HttpResponse<PageResponse<OrderView>>> getOrders(
    @Query("status") String? status,
    @Query("sortBy") String sortBy,
    @Query("direction") String direction,
    @Query("page") int page,
    @Query("size") int size,
  );
  @GET("/api/orders/{id}")
  Future<OrderView> getOrder(@Path("id") int? id);
  @POST("/api/orders")
  Future<OrderView> createOrder(@Body() OrderView order);

  @PUT("/api/orders/{id}")
  Future<OrderView> updateOrder(@Path("id") int id, @Body() OrderView order);

  @DELETE("/api/orders/{id}")
  Future<void> deleteOrder(@Path("id") int id);

  @GET("/api/orders/statistics")
  Future<OrderStatistics> getStatistics();
}
