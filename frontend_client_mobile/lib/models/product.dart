import 'dart:io';

import 'package:frontend_client_mobile/models/product_variant.dart';
import 'package:json_annotation/json_annotation.dart';

import './category.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String name;
  final String description;
  @JsonKey(includeIfNull: false)
  final String? imageUrl;
  final Category category;
  final List<ProductVariant> variants;

  @JsonKey(includeFromJson: false, includeToJson: false)
  File? image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.variants,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantsJson = json['variants'] as List<dynamic>?;
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : Category(
              id: 0,
              name: '',
              description: '',
              imageUrl: '',
              status: '',
            ),
      variants: variantsJson == null
          ? <ProductVariant>[]
          : variantsJson
                .whereType<Map<String, dynamic>>()
                .map(ProductVariant.fromJson)
                .toList(),
      image: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'category': category,
    'variants': variants.map((v) => v.toJson()).toList(),
  };

  String get priceDisplayText {
    if (variants.isEmpty) {
      return 'No variants';
    } else if (variants.length == 1) {
      return '₫${variants.first.price.basePrice}';
    } else {
      final prices = variants.map((v) => v.price.basePrice).toList()..sort();
      return '₫${prices.first} - ₫${prices.last}';
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, imageUrl: ${imageUrl ?? ''}, category: $category, variants: $variants}';
  }
}
