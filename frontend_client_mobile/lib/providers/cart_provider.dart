import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/cart_item.dart';
import 'package:frontend_client_mobile/models/cart.dart';
import 'package:frontend_client_mobile/models/order_view.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/cart_api_service.dart';
import 'package:frontend_client_mobile/services/order_service.dart';

class CartProvider extends ChangeNotifier {
  CartView? _cartView;
  final OrderService _orderService = OrderService();
  final CartApiService _cartApiService = ApiClient.getCartApiService();

  String? _error;
  bool _isLoading = false;

  CartView? get cart => _cartView;
  String? get error => _error;
  bool get isLoading => _isLoading;

  double get totalPrice => _cartView?.totalPrice ?? 0.0;

  void clear() {
    _cartView = null;
    notifyListeners();
  }

  Future<bool> addToCart({
    required int userId,
    required int variantId,
    required int quantity,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = AddToCartRequest(
        userId: userId,
        variantId: variantId,
        quantity: quantity,
      );
      await _cartApiService.addToCart(request);

      // Auto-refresh cart if we have a userId context, but here we just return success
      // The UI should call fetchCart() after this returns true.

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cartView = await _cartApiService.getCartByUserId(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateQuantity(int cartItemId, int quantity, int userId) async {
    try {
      await _cartApiService.updateQuantity(cartItemId, quantity);
      await fetchCart(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeItem(int cartItemId, int userId) async {
    try {
      await _cartApiService.removeFromCart(cartItemId);
      await fetchCart(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
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
