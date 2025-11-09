import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable()
class Color {
  final int? id;
  final String colorName;
  final String status;

  Color({
    this.id,
    required this.colorName,
    required this.status,
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
          status == other.status; // Updated operator ==

  @override
  int get hashCode => id.hashCode ^ colorName.hashCode ^ status.hashCode;

  @override
  String toString() {
    return 'Color{id: $id, colorName: $colorName, status: $status}';
  }
}
