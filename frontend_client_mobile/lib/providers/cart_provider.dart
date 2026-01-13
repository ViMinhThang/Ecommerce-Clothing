import 'package:flutter/foundation.dart';

class CartItem {
  final int productId;
  final String productName;
  final int variantId;
  final String variantName;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.variantName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _error;

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  String? get error => _error;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  Future<bool> addToCart({
    required int productId,
    required String productName,
    required int variantId,
    required String variantName,
    required double price,
    String? imageUrl,
    int quantity = 1,
  }) async {
    try {
      _error = null;
      final key = '${productId}_$variantId';

      if (_items.containsKey(key)) {
        _items.update(
          key,
          (existingCartItem) => CartItem(
            productId: existingCartItem.productId,
            productName: existingCartItem.productName,
            variantId: existingCartItem.variantId,
            variantName: existingCartItem.variantName,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + quantity,
            imageUrl: existingCartItem.imageUrl,
          ),
        );
      } else {
        _items.putIfAbsent(
          key,
          () => CartItem(
            productId: productId,
            productName: productName,
            variantId: variantId,
            variantName: variantName,
            price: price,
            quantity: quantity,
            imageUrl: imageUrl,
          ),
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void addItem(
    int productId,
    String productName,
    int variantId,
    String variantName,
    double price,
    String? imageUrl,
  ) {
    final key = '${productId}_$variantId';
    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          variantId: existingCartItem.variantId,
          variantName: existingCartItem.variantName,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItem(
          productId: productId,
          productName: productName,
          variantId: variantId,
          variantName: variantName,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String key) {
    if (!_items.containsKey(key)) {
      return;
    }
    if (_items[key]!.quantity > 1) {
      _items.update(
        key,
        (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          variantId: existingCartItem.variantId,
          variantName: existingCartItem.variantName,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }
}
