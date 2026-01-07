import 'package:json_annotation/json_annotation.dart';

part 'wishlist_item.g.dart';

@JsonSerializable()
class WishlistItem {
  final int id;
  final int productId;
  final String? productName;
  final String? productDescription;
  final String? imageUrl;
  final double? basePrice;
  final double? salePrice;
  final String? categoryName;
  final String? addedAt;

  WishlistItem({
    required this.id,
    required this.productId,
    this.productName,
    this.productDescription,
    this.imageUrl,
    this.basePrice,
    this.salePrice,
    this.categoryName,
    this.addedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistItemToJson(this);
}
