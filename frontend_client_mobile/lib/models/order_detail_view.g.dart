// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailView _$OrderDetailViewFromJson(Map<String, dynamic> json) =>
    OrderDetailView(
      id: (json['id'] as num).toInt(),
      buyerEmail: json['buyerEmail'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      status: json['status'] as String,
      createdDate: json['createdDate'] as String?,
      voucherCode: json['voucherCode'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemView.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailViewToJson(OrderDetailView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'buyerEmail': instance.buyerEmail,
      'totalPrice': instance.totalPrice,
      'discountAmount': instance.discountAmount,
      'finalPrice': instance.finalPrice,
      'status': instance.status,
      'createdDate': instance.createdDate,
      'voucherCode': instance.voucherCode,
      'items': instance.items,
    };
