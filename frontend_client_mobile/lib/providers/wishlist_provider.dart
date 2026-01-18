import 'package:flutter/foundation.dart';
import 'package:frontend_client_mobile/models/wishlist_item.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/wishlist_api_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistApiService _wishlistApiService;

  List<WishlistItem> _wishlistItems = [];
  bool _isLoading = false;
  String? _error;

  WishlistProvider() : _wishlistApiService = WishlistApiService(ApiClient.dio);

  List<WishlistItem> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _wishlistItems.length;

  Future<void> loadWishlist({int userId = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _wishlistItems = await _wishlistApiService.getWishlistByUserId(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load wishlist: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist({required int productId, int userId = 1}) async {
    try {
      final item = await _wishlistApiService.addToWishlist({
        'userId': userId,
        'productId': productId,
      });

      // Add to local list if not already present
      if (!_wishlistItems.any((i) => i.productId == productId)) {
        _wishlistItems.add(item);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = 'Failed to add to wishlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFromWishlist({
    required int productId,
    int userId = 1,
  }) async {
    try {
      await _wishlistApiService.removeFromWishlist(userId, productId);
      _wishlistItems.removeWhere((item) => item.productId == productId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to remove from wishlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> isProductInWishlist({
    required int productId,
    int userId = 1,
  }) async {
    try {
      final result = await _wishlistApiService.isInWishlist(userId, productId);
      return result['isInWishlist'] ?? false;
    } catch (e) {
      return false;
    }
  }

  bool isProductInWishlistLocal(int productId) {
    return _wishlistItems.any((item) => item.productId == productId);
  }

  Future<bool> toggleWishlist({required int productId, int userId = 1}) async {
    if (isProductInWishlistLocal(productId)) {
      return await removeFromWishlist(productId: productId, userId: userId);
    } else {
      return await addToWishlist(productId: productId, userId: userId);
    }
  }
}
