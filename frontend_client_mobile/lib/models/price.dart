import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable(createToJson: false)
class Price {
  final int id;
  final double basePrice;
  final double salePrice;

  Price({required this.id, required this.basePrice, required this.salePrice});

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'basePrice': basePrice,
      'salePrice': salePrice,
    };
    if (id != 0) {
      data['id'] = id;
    }
    return data;
  }

  Price copyWith({int? id, double? basePrice, double? salePrice}) {
    return Price(
      id: id ?? this.id,
      basePrice: basePrice ?? this.basePrice,
      salePrice: salePrice ?? this.salePrice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Price &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          basePrice == other.basePrice &&
          salePrice == other.salePrice;

  @override
  int get hashCode => id.hashCode ^ basePrice.hashCode ^ salePrice.hashCode;

  @override
  String toString() {
    return 'Price{id: $id, basePrice: $basePrice, salePrice: $salePrice}';
  }
}
