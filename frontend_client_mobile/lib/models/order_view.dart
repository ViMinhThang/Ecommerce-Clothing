import 'package:json_annotation/json_annotation.dart';
part 'order_view.g.dart';

@JsonSerializable()
class OrderView {
  final int id;
  final String buyerEmail;
  final double totalPrice;
  final String createdDate;
  final String status;

  OrderView({
    required this.id,
    required this.buyerEmail,
    required this.totalPrice,
    required this.createdDate,
    required this.status,
  });

  factory OrderView.fromJson(Map<String, dynamic> json) {
    return OrderView(
      id: json['id'],
      buyerEmail: json['buyerEmail'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      createdDate: json['createdDate'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$OrderViewToJson(this);
}
