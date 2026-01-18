import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/wishlist_item.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/favorite_api_service.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteApiService _favoriteApiService;
  final TokenStorage _tokenStorage = TokenStorage();
  
  List<WishlistItem> _items = [];
  bool _isLoading = false;
  String? _error;

  FavoriteProvider() : _favoriteApiService = FavoriteApiService(ApiClient.dio);

  List<WishlistItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get count => _items.length;

  bool isFavorite(int productId) {
    return _items.any((item) => item.productId == productId);
  }

  // Load favorites from backend
  Future<void> loadFavorites() async {
    final userId = await _tokenStorage.readUserId();
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _favoriteApiService.getFavoritesByUserId(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load favorites: ${e.toString()}';
      debugPrint('FavoriteProvider: load error - $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle favorite with API call
  Future<bool> toggleFavorite(int productId) async {
    debugPrint('FavoriteProvider: toggling product $productId');
    if (isFavorite(productId)) {
      return await removeFromFavorites(productId);
    } else {
      return await addToFavorites(productId);
    }
  }

  // Add to favorites with API call
  Future<bool> addToFavorites(int productId) async {
    final userId = await _tokenStorage.readUserId();
    if (userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return false;
    }

    if (isFavorite(productId)) return true;

    try {
      final newItem = await _favoriteApiService.addToFavorites({
        'userId': userId,
        'productId': productId,
      });
      
      debugPrint('FavoriteProvider: adding product $productId');
      _items.add(newItem);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add to favorites: ${e.toString()}';
      debugPrint('FavoriteProvider: add error - $_error');
      notifyListeners();
      return false;
    }
  }

  // Remove from favorites with API call
  Future<bool> removeFromFavorites(int productId) async {
    final userId = await _tokenStorage.readUserId();
    if (userId == null) {
      _error = 'User not logged in';
      notifyListeners();
      return false;
    }

    try {
      await _favoriteApiService.removeFromFavorites(userId, productId);
      
      debugPrint('FavoriteProvider: removing product $productId');
      _items.removeWhere((item) => item.productId == productId);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to remove from favorites: ${e.toString()}';
      debugPrint('FavoriteProvider: remove error - $_error');
      notifyListeners();
      return false;
    }
  }

  // Check if product is in favorites (from backend)
  Future<bool> isProductInFavorites(int productId) async {
    final userId = await _tokenStorage.readUserId();
    if (userId == null) return false;

    try {
      final result = await _favoriteApiService.isInFavorites(userId, productId);
      return result['isInFavorites'] ?? false;
    } catch (e) {
      debugPrint('FavoriteProvider: check error - ${e.toString()}');
      return false;
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
