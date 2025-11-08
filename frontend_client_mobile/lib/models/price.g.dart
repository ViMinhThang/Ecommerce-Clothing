// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
  id: (json['id'] as num).toInt(),
  basePrice: (json['basePrice'] as num).toDouble(),
  salePrice: (json['salePrice'] as num).toDouble(),
);

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
  'id': instance.id,
  'basePrice': instance.basePrice,
  'salePrice': instance.salePrice,
};
