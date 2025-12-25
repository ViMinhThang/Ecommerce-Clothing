class OrderStatistics {
  OrderStatistics({
    required this.totalOrderByDay,
    required this.totalPriceByDay,
    required this.totalOrderByWeek,
    required this.totalPriceByWeek,
    required this.totalOrderByMonth,
    required this.totalPriceByMonth,
  });

  final int totalOrderByDay;
  final double totalPriceByDay;
  final int totalOrderByWeek;
  final double totalPriceByWeek;
  final int totalOrderByMonth;
  final double totalPriceByMonth;

  factory OrderStatistics.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return OrderStatistics(
      totalOrderByDay: toInt(json['totalOrderByDay']),
      totalPriceByDay: toDouble(json['totalPriceByDay']),
      totalOrderByWeek: toInt(json['totalOrderByWeek']),
      totalPriceByWeek: toDouble(json['totalPriceByWeek']),
      totalOrderByMonth: toInt(json['totalOrderByMonth']),
      totalPriceByMonth: toDouble(json['totalPriceByMonth']),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalOrderByDay': totalOrderByDay,
    'totalPriceByDay': totalPriceByDay,
    'totalOrderByWeek': totalOrderByWeek,
    'totalPriceByWeek': totalPriceByWeek,
    'totalOrderByMonth': totalOrderByMonth,
    'totalPriceByMonth': totalPriceByMonth,
  };
}
