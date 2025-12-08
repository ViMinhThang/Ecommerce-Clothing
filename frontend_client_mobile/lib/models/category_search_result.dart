class CategorySearchResult {
  final int id;
  final String name;
  final String? imageUrl;

  const CategorySearchResult({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory CategorySearchResult.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawName = json['name'] ?? json['categoryName'];
    return CategorySearchResult(
      id: rawId is num ? rawId.toInt() : int.tryParse('$rawId') ?? 0,
      name: (rawName ?? '').toString(),
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
    );
  }
}
