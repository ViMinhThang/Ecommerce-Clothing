import 'package:flutter/material.dart';

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
    _error = null;
    notifyListeners();

    try {
      if (quantity <= 0) {
        _error = 'Quantity must be greater than 0';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final request = AddToCartRequest(
        userId: userId,
        variantId: variantId,
        quantity: quantity,
      );

      final response = await _cartApiService.addToCart(request);

      _cartView = response;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      String errorMessage = _extractErrorMessage(e.toString());
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _extractErrorMessage(String error) {
    if (error.contains('Product variant is not available')) {
      return 'This product is no longer available for purchase';
    }
    if (error.contains('Quantity must be greater than 0')) {
      return 'Please enter a valid quantity';
    }
    if (error.contains('Cannot add items to another user\'s cart')) {
      return 'You can only add items to your own cart';
    }
    if (error.contains('User not found')) {
      return 'User account not found';
    }
    if (error.contains('Product variant not found')) {
      return 'Product not found';
    }
    if (error.contains('Connection')) {
      return 'Network connection error. Please try again.';
    }

    return 'Failed to add item to cart. Please try again.';
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
      if (_cartView != null) {
        final itemIndex = _cartView!.items.indexWhere(
          (item) => item.id == cartItemId,
        );
        if (itemIndex >= 0) {
          final updatedItem = _cartView!.items[itemIndex];

          final oldSubtotal = updatedItem.subtotal;

          final newItem = CartItemView(
            id: updatedItem.id,
            variantId: updatedItem.variantId,
            productName: updatedItem.productName,
            productImage: updatedItem.productImage,
            colorName: updatedItem.colorName,
            sizeName: updatedItem.sizeName,
            quantity: quantity,
            price: updatedItem.price,
            subtotal: updatedItem.price * quantity,
          );

          _cartView!.items[itemIndex] = newItem;

          final priceDifference = (newItem.subtotal - oldSubtotal);
          _cartView = CartView(
            id: _cartView!.id,
            userId: _cartView!.userId,
            items: _cartView!.items,
            totalPrice: _cartView!.totalPrice + priceDifference,
          );

          notifyListeners();
        }
      }

      await _cartApiService.updateQuantity(cartItemId, quantity);
    } catch (e) {
      _error = e.toString();
      await fetchCart(userId);
    }
  }

  Future<void> removeItem(int cartItemId, int userId) async {
    try {
      if (_cartView != null) {
        final itemIndex = _cartView!.items.indexWhere(
          (item) => item.id == cartItemId,
        );
        if (itemIndex >= 0) {
          final removedItem = _cartView!.items[itemIndex];
          final newTotalPrice = _cartView!.totalPrice - removedItem.subtotal;

          _cartView!.items.removeAt(itemIndex);
          _cartView = CartView(
            id: _cartView!.id,
            userId: _cartView!.userId,
            items: _cartView!.items,
            totalPrice: newTotalPrice,
          );

          notifyListeners();
        }
      }

      await _cartApiService.removeFromCart(cartItemId);
    } catch (e) {
      _error = e.toString();
      await fetchCart(userId);
    }
  }

  Future<OrderView> checkout({
    required String buyerEmail,
    String? voucherCode,
  }) async {
    if (_cartView == null || _cartView!.items.isEmpty) {
      throw Exception('Cart is empty');
    }

    final cartItemIds = _cartView!.items.map((item) => item.id).toList();
    final res = await _orderService.createOrderFromCart(
      cartItemIds: cartItemIds,
      voucherCode: voucherCode,
    );
    clear();
    return res;
  }

  Future<void> removeSelectedItems(List<int> itemIds, int userId) async {
    try {
      if (_cartView != null) {
        double removedTotal = 0;
        _cartView!.items.removeWhere((item) {
          if (itemIds.contains(item.id)) {
            removedTotal += item.subtotal;
            return true;
          }
          return false;
        });

        // Ensure total price doesn't go negative
        final newTotal = _cartView!.totalPrice - removedTotal;
        _cartView = CartView(
          id: _cartView!.id,
          userId: _cartView!.userId,
          items: _cartView!.items,
          totalPrice: newTotal < 0 ? 0 : newTotal,
        );

        notifyListeners();
      }

      for (final itemId in itemIds) {
        await _cartApiService.removeFromCart(itemId);
      }
    } catch (e) {
      _error = e.toString();
      await fetchCart(userId);
    }
  }
}
