import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/stock_check_response.dart';
import 'package:retrofit/retrofit.dart';

part 'inventory_api_service.g.dart';

@RestApi()
abstract class InventoryApiService {
  factory InventoryApiService(Dio dio, {String? baseUrl}) = _InventoryApiService;

  @GET("/api/inventory/check/{variantId}")
  Future<StockCheckResponse> checkStock(@Path("variantId") int variantId);

  @GET("/api/inventory/check/{variantId}/{quantity}")
  Future<bool> hasSufficientStock(
    @Path("variantId") int variantId,
    @Path("quantity") int quantity,
  );
}
