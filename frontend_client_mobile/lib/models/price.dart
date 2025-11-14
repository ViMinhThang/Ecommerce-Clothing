import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable()
class Price {
  final int id;
  final double basePrice;
  final double salePrice;

  Price({
    required this.id,
    required this.basePrice,
    required this.salePrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

  Map<String, dynamic> toJson() => _$PriceToJson(this);

  @override
  String toString() {
    return 'Price{id: $id, basePrice: $basePrice, salePrice: $salePrice}';
  }
}
