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

  factory OrderDetailView.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailViewFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailViewToJson(this);
}
