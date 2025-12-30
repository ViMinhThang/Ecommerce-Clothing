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
    _error = null;
    notifyListeners();

    try {
      // ✅ VALIDATION: quantity check (frontend pre-validation)
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
      
      // ✅ Update local cart state with response
      _cartView = response;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // ✅ IMPROVED ERROR HANDLING: Extract meaningful error message
      String errorMessage = _extractErrorMessage(e.toString());
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ Helper method to extract readable error messages
  String _extractErrorMessage(String error) {
    // Handle DioException with backend error response
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
    
    // Default error message
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
      // Update local state immediately for smooth UI
      if (_cartView != null) {
        final itemIndex = _cartView!.items.indexWhere((item) => item.id == cartItemId);
        if (itemIndex >= 0) {
          final updatedItem = _cartView!.items[itemIndex];
          final oldQuantity = updatedItem.quantity;
          final oldSubtotal = updatedItem.subtotal;
          
          // Create updated item with new quantity
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
          
          // Update list
          _cartView!.items[itemIndex] = newItem;
          
          // Recalculate total
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
      
      // Call API in background without blocking UI
      await _cartApiService.updateQuantity(cartItemId, quantity);
    } catch (e) {
      _error = e.toString();
      // Reload from server on error
      await fetchCart(userId);
    }
  }

  Future<void> removeItem(int cartItemId, int userId) async {
    try {
      // Update local state immediately
      if (_cartView != null) {
        final itemIndex = _cartView!.items.indexWhere((item) => item.id == cartItemId);
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
      
      // Call API in background
      await _cartApiService.removeFromCart(cartItemId);
    } catch (e) {
      _error = e.toString();
      // Reload from server on error
      await fetchCart(userId);
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
