// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductView _$ProductViewFromJson(Map<String, dynamic> json) => ProductView(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String,
  basePrice: (json['basePrice'] as num).toDouble(),
  salePrice: (json['salePrice'] as num).toDouble(),
  description: json['description'] as String,
);

Map<String, dynamic> _$ProductViewToJson(ProductView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'basePrice': instance.basePrice,
      'salePrice': instance.salePrice,
      'description': instance.description,
    };
