class FilterResponse {
  final List<String> sizes;
  final List<String> materials;
  final List<String> colors;
  final List<String> seasons;
  final double minPrice;
  final double maxPrice;

  const FilterResponse({
    this.sizes = const [],
    this.materials = const [],
    this.colors = const [],
    this.seasons = const [],
    this.minPrice = 0.0,
    this.maxPrice = 0.0,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) {
    List<String> safeStringList(dynamic v) {
      if (v == null) return const [];
      if (v is List) {
        return v.where((e) => e != null).map((e) => e.toString()).toList();
      }
      // fallback: nếu backend lỡ gửi string "A,B,C"
      if (v is String && v.isNotEmpty) {
        return v
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return const [];
    }

    return FilterResponse(
      // dùng *List thay vì field string gộp
      sizes: safeStringList(json['sizeList']),
      materials: safeStringList(json['materialList']),
      colors: safeStringList(json['colorList']),
      seasons: safeStringList(json['seasonList']),
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'FilterResponse(sizes: $sizes, materials: $materials, colors: $colors, seasons: $seasons, minPrice: $minPrice, maxPrice: $maxPrice)';
  }
}
