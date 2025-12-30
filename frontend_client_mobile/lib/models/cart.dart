class CartView {
  final int? id;
  final int userId;
  final List<CartItemView> items;
  final double totalPrice;

  CartView({
    this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
  });

  factory CartView.fromJson(Map<String, dynamic> json) {
    return CartView(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemView.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
    };
  }
}

class CartItemView {
  final int id;
  final int variantId;
  final String productName;
  final String productImage;
  final String colorName;
  final String sizeName;
  final int quantity;
  final double price;
  final double subtotal;

  CartItemView({
    required this.id,
    required this.variantId,
    required this.productName,
    required this.productImage,
    required this.colorName,
    required this.sizeName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory CartItemView.fromJson(Map<String, dynamic> json) {
    return CartItemView(
      id: json['id'] as int,
      variantId: json['variantId'] as int,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      colorName: json['colorName'] as String,
      sizeName: json['sizeName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variantId': variantId,
      'productName': productName,
      'productImage': productImage,
      'colorName': colorName,
      'sizeName': sizeName,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
    };
  }
}

class AddToCartRequest {
  final int userId;
  final int variantId;
  final int quantity;

  AddToCartRequest({
    required this.userId,
    required this.variantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'variantId': variantId, 'quantity': quantity};
  }
}
