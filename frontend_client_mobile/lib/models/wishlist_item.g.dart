// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) => WishlistItem(
  id: (json['id'] as num).toInt(),
  productId: (json['productId'] as num).toInt(),
  productName: json['productName'] as String?,
  productDescription: json['productDescription'] as String?,
  imageUrl: json['imageUrl'] as String?,
  basePrice: (json['basePrice'] as num?)?.toDouble(),
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  categoryName: json['categoryName'] as String?,
  addedAt: json['addedAt'] as String?,
);

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productDescription': instance.productDescription,
      'imageUrl': instance.imageUrl,
      'basePrice': instance.basePrice,
      'salePrice': instance.salePrice,
      'categoryName': instance.categoryName,
      'addedAt': instance.addedAt,
    };
