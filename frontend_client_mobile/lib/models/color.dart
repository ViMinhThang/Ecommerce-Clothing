import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable()
class Color {
  final int? id;
  final String colorName;
  final String status;
  final String? colorCode;

  Color({
    this.id,
    required this.colorName,
    required this.status,
    this.colorCode,
  }); // Updated constructor

  factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);

  Map<String, dynamic> toJson() => _$ColorToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Color &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          colorName == other.colorName &&
          status == other.status &&
          colorCode == other.colorCode; // Updated operator ==

  @override
  int get hashCode =>
      id.hashCode ^ colorName.hashCode ^ status.hashCode ^ colorCode.hashCode;

  @override
  String toString() {
    return 'Color{id: $id, colorName: $colorName, status: $status, colorCode: $colorCode}';
  }
}
