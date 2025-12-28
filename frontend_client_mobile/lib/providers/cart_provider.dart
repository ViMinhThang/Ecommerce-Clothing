import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/cart.dart';
import 'package:frontend_client_mobile/services/api/cart_api_service.dart';
import 'package:dio/dio.dart';

class CartProvider with ChangeNotifier {
  final CartApiService _cartApiService;
  
  CartView? _cart;
  bool _isLoading = false;
  String? _error;

  CartView? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _cart?.items.length ?? 0;
  double get totalPrice => _cart?.totalPrice ?? 0.0;

  CartProvider(Dio dio)
      : _cartApiService = CartApiService(dio, baseUrl: dio.options.baseUrl);

  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartApiService.getCartByUserId(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load cart: $e';
      _cart = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart({
    required int userId,
    required int variantId,
    required int quantity,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = AddToCartRequest(
        userId: userId,
        variantId: variantId,
        quantity: quantity,
      );
      
      _cart = await _cartApiService.addToCart(request);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add to cart: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> removeItem(int cartItemId, int userId) async {
    try {
      await _cartApiService.removeFromCart(cartItemId);
      await fetchCart(userId); // Refresh cart
    } catch (e) {
      _error = 'Failed to remove item: $e';
      notifyListeners();
    }
  }

  Future<void> updateQuantity(int cartItemId, int quantity, int userId) async {
    try {
      await _cartApiService.updateQuantity(cartItemId, quantity);
      await fetchCart(userId); // Refresh cart
    } catch (e) {
      _error = 'Failed to update quantity: $e';
      notifyListeners();
    }
  }

  Future<void> clearCart(int userId) async {
    try {
      await _cartApiService.clearCart(userId);
      _cart = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear cart: $e';
      notifyListeners();
    }
  }
}
