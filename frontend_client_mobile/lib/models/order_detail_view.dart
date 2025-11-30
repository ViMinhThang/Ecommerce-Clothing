import 'package:frontend_client_mobile/models/order_item_view.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_detail_view.g.dart';

@JsonSerializable()
class OrderDetailView {
  final int id;
  final String buyerEmail;
  final double totalPrice;
  final String status;
  final List<OrderItemView> items;

  OrderDetailView({
    required this.id,
    required this.buyerEmail,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory OrderDetailView.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return OrderDetailView(
      id: json['id'],
      buyerEmail: json['buyerEmail'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      items: itemsJson.map((e) => OrderItemView.fromJson(e)).toList(),
    );
  }
}

