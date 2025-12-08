import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/models/price.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_variant.g.dart';

@JsonSerializable()
class ProductVariant {
  final int id;
  final Price price;
  final Size size;
  final Color color;

  ProductVariant({
    required this.id,
    required this.price,
    required this.size,
    required this.color,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final priceJson = json['price'];
    final sizeJson = json['size'];
    final colorJson = json['color'];
    return ProductVariant(
      id: (json['id'] as num?)?.toInt() ?? 0,
      price: priceJson is Map<String, dynamic>
          ? Price.fromJson(priceJson)
          : Price(id: 0, basePrice: 0, salePrice: 0),
      size: sizeJson is Map<String, dynamic>
          ? Size.fromJson(sizeJson)
          : Size(id: 0, sizeName: '', status: ''),
      color: colorJson is Map<String, dynamic>
          ? Color.fromJson(colorJson)
          : Color(id: 0, colorName: '', status: '', colorCode: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price.toJson(),
      'sizeId': size.id,
      'colorId': color.id,
    };
  }

  @override
  String toString() {
    return 'ProductVariant{id: $id, price: $price, size: $size, color: $color}';
  }
}
