import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable()
class ProductImage {
  final int id;
  final String imageUrl;
  final int displayOrder;
  final bool isPrimary;

  const ProductImage({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
    required this.isPrimary,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);

  ProductImage copyWith({
    int? id,
    String? imageUrl,
    int? displayOrder,
    bool? isPrimary,
  }) {
    return ProductImage(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  @override
  String toString() {
    return 'ProductImage{id: $id, imageUrl: $imageUrl, displayOrder: $displayOrder, isPrimary: $isPrimary}';
  }
}
