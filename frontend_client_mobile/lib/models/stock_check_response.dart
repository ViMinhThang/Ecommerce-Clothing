class StockCheckResponse {
  final int variantId;
  final int availableStock;
  final bool inStock;
  final bool isLowStock;
  final String stockStatus; // "IN_STOCK", "LOW_STOCK", "OUT_OF_STOCK"

  StockCheckResponse({
    required this.variantId,
    required this.availableStock,
    required this.inStock,
    required this.isLowStock,
    required this.stockStatus,
  });

  factory StockCheckResponse.fromJson(Map<String, dynamic> json) {
    return StockCheckResponse(
      variantId: json['variantId'] as int? ?? 0,
      availableStock: json['availableStock'] as int? ?? 0,
      inStock: json['inStock'] as bool? ?? false,
      isLowStock: json['isLowStock'] as bool? ?? false,
      stockStatus: json['stockStatus'] as String? ?? 'OUT_OF_STOCK',
    );
  }
}
