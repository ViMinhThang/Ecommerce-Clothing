import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/models/price.dart';
import 'package:frontend_client_mobile/models/size.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_variant.g.dart';

@JsonSerializable(createToJson: false)
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

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'price': price.toJson(),
      'sizeId': size.id,
      'colorId': color.id,
    };
    if (id != 0) {
      data['id'] = id;
    }
    return data;
  }

  ProductVariant copyWith({int? id, Price? price, Size? size, Color? color}) {
    return ProductVariant(
      id: id ?? this.id,
      price: price ?? this.price,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariant &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          price == other.price &&
          size == other.size &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^ price.hashCode ^ size.hashCode ^ color.hashCode;

  @override
  String toString() {
    return 'ProductVariant{id: $id, price: $price, size: $size, color: $color}';
  }
}
