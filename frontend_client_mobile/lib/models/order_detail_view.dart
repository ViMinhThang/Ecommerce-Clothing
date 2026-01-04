import 'package:json_annotation/json_annotation.dart';
import 'order_item_view.dart';
part 'order_detail_view.g.dart';

@JsonSerializable()
class OrderDetailView {
  final int id;
  final String buyerEmail;
  final double totalPrice;
  final double discountAmount;
  final double finalPrice;
  final String status;
  final String? createdDate;
  final String? voucherCode;
  final List<OrderItemView> items;

  OrderDetailView({
    required this.id,
    required this.buyerEmail,
    required this.totalPrice,
    required this.discountAmount,
    required this.finalPrice,
    required this.status,
    this.createdDate,
    this.voucherCode,
    required this.items,
  });

  factory OrderDetailView.fromJson(Map<String, dynamic> json) {
    return OrderDetailView(
      id: json['id'] ?? 0,
      buyerEmail: json['buyerEmail'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdDate: json['createdDate'],
      voucherCode: json['voucherCode'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemView.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => _$OrderDetailViewToJson(this);
}
