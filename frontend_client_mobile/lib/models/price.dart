import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable()
class Price {
  final int id;
  final double basePrice;
  final double salePrice;

  Price({required this.id, required this.basePrice, required this.salePrice});

  factory Price.fromJson(Map<String, dynamic> json) {
    final base = json['basePrice'];
    final sale = json['salePrice'];
    return Price(
      id: (json['id'] as num?)?.toInt() ?? 0,
      basePrice: base is num ? base.toDouble() : double.tryParse('$base') ?? 0,
      salePrice: sale is num ? sale.toDouble() : double.tryParse('$sale') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$PriceToJson(this);

  @override
  String toString() {
    return 'Price{id: $id, basePrice: $basePrice, salePrice: $salePrice}';
  }
}
