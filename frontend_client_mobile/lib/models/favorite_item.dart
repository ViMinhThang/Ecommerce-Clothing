import 'package:frontend_client_mobile/models/product.dart';

class FavoriteItem {
  final int productId;
  final String productName;
  final String? imageUrl;
  final double price;
  final Product product;

  FavoriteItem({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.price,
    required this.product,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}
