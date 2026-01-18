import 'package:json_annotation/json_annotation.dart';

part 'size.g.dart';

@JsonSerializable()
class Size {
  final int? id;
  final String sizeName;
  final String status;
  Size({required this.id, required this.sizeName, required this.status});

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);

  Map<String, dynamic> toJson() => _$SizeToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Size &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sizeName == other.sizeName &&
          status == other.status; // Updated operator ==

  @override
  int get hashCode => id.hashCode ^ sizeName.hashCode ^ status.hashCode; // Updated hashCode

  @override
  String toString() {
    return 'Size{id: $id, sizeName: $sizeName, status: $status}'; // Updated toString
  }
}
