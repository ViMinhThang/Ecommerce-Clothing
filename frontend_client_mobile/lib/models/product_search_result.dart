class ProductSearchResult {
  final int id;
  final String name;
  final String? imageUrl;

  const ProductSearchResult({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory ProductSearchResult.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return ProductSearchResult(
      id: rawId is num ? rawId.toInt() : int.tryParse('$rawId') ?? 0,
      name: (json['name'] ?? '').toString(),
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
    );
  }
}
