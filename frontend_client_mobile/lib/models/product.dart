import 'dart:io';

import 'package:frontend_client_mobile/models/product_image.dart';
import 'package:frontend_client_mobile/models/product_variant.dart';
import 'package:json_annotation/json_annotation.dart';

import './category.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String name;
  final String description;
  @JsonKey(name: 'images', defaultValue: [])
  final List<ProductImage> images;
  final Category category;
  final List<ProductVariant> variants;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? selectedImages;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.images = const [],
    required this.category,
    required this.variants,
    this.selectedImages,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// Get the primary image URL for this product
  String? get primaryImageUrl {
    if (images.isNotEmpty) {
      final primary = images.where((img) => img.isPrimary).toList();
      if (primary.isNotEmpty) {
        return primary.first.imageUrl;
      }
      return images.first.imageUrl;
    }
    return null;
  }

  /// Get all image URLs in display order
  List<String> get imageUrls {
    return images.map((img) => img.imageUrl).toList();
  }

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

  Product copyWith({
    int? id,
    String? name,
    String? description,
    List<ProductImage>? images,
    Category? category,
    List<ProductVariant>? variants,
    List<File>? selectedImages,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      variants: variants ?? this.variants,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: ${images.length}, category: $category, variants: $variants}';
  }
}
