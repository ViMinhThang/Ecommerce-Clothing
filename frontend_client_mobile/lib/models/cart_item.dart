import 'package:frontend_client_mobile/models/product_variant.dart';

class CartItem {
  final int productId;
  final String productName;
  final String? productImage;
  final ProductVariant variant;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.variant,
    this.quantity = 1,
  });

  double get lineTotal => variant.price.basePrice * quantity;
}
