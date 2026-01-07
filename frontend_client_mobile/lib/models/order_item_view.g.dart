// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemView _$OrderItemViewFromJson(Map<String, dynamic> json) =>
    OrderItemView(
      id: (json['id'] as num).toInt(),
      productName: json['productName'] as String?,
      size: json['size'] as String?,
      color: json['color'] as String?,
      material: json['material'] as String?,
      imageUrl: json['imageUrl'] as String?,
      priceAtPurchase: (json['priceAtPurchase'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$OrderItemViewToJson(OrderItemView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'size': instance.size,
      'color': instance.color,
      'material': instance.material,
      'imageUrl': instance.imageUrl,
      'priceAtPurchase': instance.priceAtPurchase,
      'quantity': instance.quantity,
    };
