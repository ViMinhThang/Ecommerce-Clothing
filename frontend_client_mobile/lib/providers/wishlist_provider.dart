import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/wishlist_item.dart';
import 'package:frontend_client_mobile/models/product.dart';

class WishListProvider extends ChangeNotifier {
  final List<WishListItem> _items = [];

  List<WishListItem> get items => List.unmodifiable(_items);

  bool isFavorite(int productId) {
    return _items.any((e) => e.productId == productId);
  }

  void addItem(WishListItem item) {
    if (!isFavorite(item.productId)) {
      _items.add(item);
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((e) => e.productId == productId);
    notifyListeners();
  }

  void toggleFavorite(WishListItem item) {
    if (isFavorite(item.productId)) {
      removeItem(item.productId);
    } else {
      addItem(item);
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get count => _items.length;
}
