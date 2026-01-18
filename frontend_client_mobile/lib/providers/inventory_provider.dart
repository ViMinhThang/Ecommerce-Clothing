import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/stock_check_response.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/inventory_api_service.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryApiService _inventoryApiService;
  final Map<int, StockCheckResponse> _stockCache = {};

  InventoryProvider() : _inventoryApiService = InventoryApiService(ApiClient.dio);

  /// Check stock for a variant and cache the result
  Future<StockCheckResponse?> checkStock(int variantId) async {
    try {
      final response = await _inventoryApiService.checkStock(variantId);
      _stockCache[variantId] = response;
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint('Error checking stock: $e');
      return null;
    }
  }

  /// Check if sufficient stock is available
  Future<bool> hasSufficientStock(int variantId, int quantity) async {
    try {
      return await _inventoryApiService.hasSufficientStock(variantId, quantity);
    } catch (e) {
      debugPrint('Error checking sufficient stock: $e');
      return false;
    }
  }

  /// Get cached stock info (if available)
  StockCheckResponse? getCachedStock(int variantId) {
    return _stockCache[variantId];
  }

  /// Check if variant is in stock (from cache)
  bool isInStock(int variantId) {
    final stock = _stockCache[variantId];
    return stock != null && stock.inStock;
  }

  /// Check if variant is low stock (from cache)
  bool isLowStock(int variantId) {
    final stock = _stockCache[variantId];
    return stock != null && stock.isLowStock;
  }

  /// Get available stock count (from cache)
  int getAvailableStock(int variantId) {
    final stock = _stockCache[variantId];
    return stock?.availableStock ?? 0;
  }

  /// Clear stock cache
  void clearCache() {
    _stockCache.clear();
    notifyListeners();
  }
}
