import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable()
class Color {
  final int id;
  final String colorName;

  Color({required this.id, required this.colorName});

  factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);

  Map<String, dynamic> toJson() => _$ColorToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Color &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          colorName == other.colorName;

  @override
  int get hashCode => id.hashCode ^ colorName.hashCode;

  @override
  String toString() {
    return 'Color{id: $id, colorName: $colorName}';
  }
}
