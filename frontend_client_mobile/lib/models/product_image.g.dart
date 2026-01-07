// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
  id: (json['id'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  displayOrder: (json['displayOrder'] as num).toInt(),
  isPrimary: json['isPrimary'] as bool,
);

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'displayOrder': instance.displayOrder,
      'isPrimary': instance.isPrimary,
    };
