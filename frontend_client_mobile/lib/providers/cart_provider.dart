import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/cart_item.dart';
import 'package:frontend_client_mobile/models/order_view.dart';
import 'package:frontend_client_mobile/services/order_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final OrderService _orderService = OrderService();

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final idx = _items.indexWhere((e) => e.variant.id == item.variant.id);
    if (idx >= 0) {
      _items[idx].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((e) => e.variant.id == item.variant.id);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int qty) {
    final idx = _items.indexWhere((e) => e.variant.id == item.variant.id);
    if (idx >= 0) {
      _items[idx].quantity = qty;
      if (_items[idx].quantity <= 0) _items.removeAt(idx);
      notifyListeners();
    }
  }

  double get totalPrice {
    return _items.fold(0.0, (p, e) => p + e.lineTotal);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<OrderView> checkout({required String buyerEmail}) async {
    final order = OrderView(
      id: 0,
      buyerEmail: buyerEmail,
      totalPrice: totalPrice,
      createdDate: '',
      status: 'PENDING',
    );
    final res = await _orderService.createOrder(order);
    clear();
    return res;
  }
}
