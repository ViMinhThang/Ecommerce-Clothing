class FilterResponse {
  final List<String> sizes;
  final List<String> materials;
  final List<String> colors;
  final List<String> seasons;
  final double minPrice;
  final double maxPrice;

  FilterResponse({
    this.sizes = const [],
    this.materials = const [],
    this.colors = const [],
    this.seasons = const [],
    this.minPrice = 0.0,
    this.maxPrice = 0.0,
  });

  // Factory method để parse JSON từ Server
  factory FilterResponse.fromJson(Map<String, dynamic> json) {
    return FilterResponse(
      // Kiểm tra null và cast an toàn sang List<String>
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],

      materials: json['materials'] != null
          ? List<String>.from(json['materials'])
          : [],

      colors: json['colors'] != null ? List<String>.from(json['colors']) : [],

      seasons: json['seasons'] != null
          ? List<String>.from(json['seasons'])
          : [],

      // Lưu ý quan trọng: JSON số có thể là int hoặc double.
      // Dùng 'num' để hứng cả 2, sau đó .toDouble() để tránh lỗi crash app.
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Phương thức hỗ trợ debug (in ra console xem thử)
  @override
  String toString() {
    return 'FilterResponse(sizes: $sizes, minPrice: $minPrice, maxPrice: $maxPrice)';
  }
}
