// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Size _$SizeFromJson(Map<String, dynamic> json) => Size(
  id: (json['id'] as num?)?.toInt(),
  sizeName: json['sizeName'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$SizeToJson(Size instance) => <String, dynamic>{
  'id': instance.id,
  'sizeName': instance.sizeName,
  'status': instance.status,
};
