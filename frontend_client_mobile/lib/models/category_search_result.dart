class CategorySearchResult {
  final int id;
  final String name;
  final String? image;

  const CategorySearchResult({
    required this.id,
    required this.name,
    this.image,
  });

  factory CategorySearchResult.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    return CategorySearchResult(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
      image: json['image'] as String?,
    );
  }
}
