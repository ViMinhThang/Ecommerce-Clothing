class DashboardView {
  final double totalRevenue;
  final int totalOrder;
  final int totalProduct;
  final int totalUser;

  DashboardView({
    required this.totalRevenue,
    required this.totalOrder,
    required this.totalProduct,
    required this.totalUser,
  });

  factory DashboardView.fromJson(Map<String, dynamic> json) => DashboardView(
    totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
    totalOrder: (json['totalOrder'] as num?)?.toInt() ?? 0,
    totalProduct: (json['totalProduct'] as num?)?.toInt() ?? 0,
    totalUser: (json['totalUser'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'totalRevenue': totalRevenue,
    'totalOrder': totalOrder,
    'totalProduct': totalProduct,
    'totalUser': totalUser,
  };
}
