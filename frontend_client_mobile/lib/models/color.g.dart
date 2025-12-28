// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color _$ColorFromJson(Map<String, dynamic> json) => Color(
  id: (json['id'] as num?)?.toInt(),
  colorName: json['colorName'] as String,
  status: json['status'] as String,
  colorCode: json['colorCode'] as String?,
);

Map<String, dynamic> _$ColorToJson(Color instance) => <String, dynamic>{
  'id': instance.id,
  'colorName': instance.colorName,
  'status': instance.status,
  'colorCode': instance.colorCode,
};
