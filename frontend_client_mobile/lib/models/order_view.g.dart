// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderView _$OrderViewFromJson(Map<String, dynamic> json) => OrderView(
  id: (json['id'] as num).toInt(),
  buyerEmail: json['buyerEmail'] as String,
  totalPrice: (json['totalPrice'] as num).toDouble(),
  createdDate: json['createdDate'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$OrderViewToJson(OrderView instance) => <String, dynamic>{
  'id': instance.id,
  'buyerEmail': instance.buyerEmail,
  'totalPrice': instance.totalPrice,
  'createdDate': instance.createdDate,
  'status': instance.status,
};
