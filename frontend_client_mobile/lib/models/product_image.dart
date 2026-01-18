import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable()
class ProductImage {
  final int id;
  final String imageUrl;
  final int displayOrder;
  final bool isPrimary;

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
    required this.isPrimary,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);

  @override
  String toString() {
    return 'ProductImage{id: $id, imageUrl: $imageUrl, displayOrder: $displayOrder, isPrimary: $isPrimary}';
  }
}
