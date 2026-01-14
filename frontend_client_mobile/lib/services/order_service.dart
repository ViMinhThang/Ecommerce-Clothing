import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/order_statistics.dart';
import 'package:frontend_client_mobile/models/order_view.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/order_api_service.dart';

class OrderService {
  final OrderApiService _apiOrderService = ApiClient.getOrderApiService();

  Future<PageResponse<OrderView>> getOrders({
    String? status,
    String? sortBy = "createdDate",
    String? direction = "DESC",
    int page = 0,
    int size = 10,
  }) async {
    final response = await _apiOrderService.getOrders(
      status,
      sortBy!,
      direction!,
      page,
      size,
    );
    return response.data;
  }

  Future<OrderView> createOrder(OrderView order) async {
    return await _apiOrderService.createOrder(order);
  }

  Future<OrderView> createOrderFromCart({
    required List<int> cartItemIds,
    String? voucherCode,
  }) async {
    return await _apiOrderService.createOrderFromCart({
      'cartItemIds': cartItemIds,
      'voucherCode': voucherCode,
    });
  }

  Future<OrderView> updateOrder(int id, OrderView order) async {
    return await _apiOrderService.updateOrder(id, order);
  }

  Future<void> deleteOrder(int id) async {
    return await _apiOrderService.deleteOrder(id);
  }

  Future<OrderView> getOrder(int id) async {
    return await _apiOrderService.getOrder(id);
  }

  Future<OrderStatistics> getStatistics() async {
    return await _apiOrderService.getStatistics();
  }
}
