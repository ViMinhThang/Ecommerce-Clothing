import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int? id; // Changed to nullable to match backend auto-generated ID
  final String name; // Renamed from title
  final String description; // Added description field
  final String imageUrl;
  final String status; // Added status field

  Category({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
  }); // Updated constructor

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          status == other.status; // Updated operator ==

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      status.hashCode; // Updated hashCode

  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description, imageUrl: $imageUrl, status: $status}'; // Updated toString
  }
}