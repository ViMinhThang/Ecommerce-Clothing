// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) => OrderRequest(
  cartItemIds: (json['cartItemIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{'cartItemIds': instance.cartItemIds};
