class ProductSearchResult {
  final int id;
  final String name;
  final String? thumbnail;
  final double? price;
  final String? categoryName;

  const ProductSearchResult({
    required this.id,
    required this.name,
    this.thumbnail,
    this.price,
    this.categoryName,
  });

  factory ProductSearchResult.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final priceValue = json['price'];
    return ProductSearchResult(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
      thumbnail: json['thumbnail'] as String?,
      price: priceValue is num
          ? priceValue.toDouble()
          : double.tryParse(priceValue?.toString() ?? ''),
      categoryName: json['categoryName']?.toString(),
    );
  }
}
