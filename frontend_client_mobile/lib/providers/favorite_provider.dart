import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/favorite_item.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteItem> _items = [];

  List<FavoriteItem> get items => List.unmodifiable(_items);

  bool isFavorite(int productId) {
    return _items.any((e) => e.productId == productId);
  }

  void toggleFavorite(FavoriteItem item) {
    print('FavoriteProvider: toggling product ${item.productId}');
    if (isFavorite(item.productId)) {
      removeItem(item.productId);
    } else {
      addItem(item);
    }
  }

  void addItem(FavoriteItem item) {
    if (!isFavorite(item.productId)) {
      print('FavoriteProvider: adding item ${item.productName}');
      _items.add(item);
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    print('FavoriteProvider: removing item $productId');
    _items.removeWhere((e) => e.productId == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get count => _items.length;
}
