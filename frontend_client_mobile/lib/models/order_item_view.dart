import 'package:json_annotation/json_annotation.dart';
part 'order_item_view.g.dart';

@JsonSerializable()
class OrderItemView {
  final int id;
  final String productName;
  final String? size;
  final String? color;
  final String? material;
  final String? imageUrl;
  final double priceAtPurchase;
  final int quantity;

  OrderItemView({
    required this.id,
    required this.productName,
    this.size,
    this.color,
    this.material,
    this.imageUrl,
    required this.priceAtPurchase,
    required this.quantity,
  });

  factory OrderItemView.fromJson(Map<String, dynamic> json) {
    return OrderItemView(
      id: json['id'],
      productName: json['productName'] ?? '',
      size: json['size'],
      color: json['color'],
      material: json['material'],
      imageUrl: json['imageUrl'],
      priceAtPurchase: (json['priceAtPurchase'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}