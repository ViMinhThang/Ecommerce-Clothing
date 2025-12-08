import 'package:json_annotation/json_annotation.dart';

part 'PageResponse.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageResponse<T> {
  final List<T> content;

  @JsonKey(name: 'totalElements')
  final int totalElements;

  @JsonKey(name: 'totalPages')
  final int totalPages;

  @JsonKey(name: 'size')
  final int size;

  @JsonKey(name: 'number')
  final int number;

  PageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final flattened = Map<String, dynamic>.from(json);
    final page = json['page'];
    if (page is Map<String, dynamic>) {
      flattened.addAll(page);
    }
    return _$PageResponseFromJson(flattened, fromJsonT);
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PageResponseToJson(this, toJsonT);
}
