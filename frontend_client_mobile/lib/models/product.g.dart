// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String?,
  category: Category.fromJson(json['category'] as Map<String, dynamic>),
  variants: (json['variants'] as List<dynamic>)
      .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
      .toList(),
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': ?instance.imageUrl,
  'category': instance.category,
  'variants': instance.variants,
  'images': ?instance.images,
};
