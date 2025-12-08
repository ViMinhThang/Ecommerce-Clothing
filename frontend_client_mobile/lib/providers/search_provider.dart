import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category_search_result.dart';
import 'package:frontend_client_mobile/models/product_search_result.dart';
import 'package:frontend_client_mobile/services/search_service.dart';

class SearchProvider with ChangeNotifier {
  SearchProvider({SearchService? searchService})
    : _searchService = searchService ?? SearchService();

  final SearchService _searchService;

  bool _isSearching = false;
  List<ProductSearchResult> _productResults = const [];
  List<CategorySearchResult> _categoryResults = const [];
  String _lastSignature = '';
  int _activeSearchToken = 0;

  bool get isSearching => _isSearching;
  List<ProductSearchResult> get productResults => _productResults;
  List<CategorySearchResult> get categoryResults => _categoryResults;

  Future<void> search(
    String keyword, {
    int? categoryId,
    bool includeCategories = true,
    bool includeProducts = true,
  }) async {
    final trimmed = keyword.trim();
    final signature =
        '$trimmed|cat:$categoryId|c:$includeCategories|p:$includeProducts';
    if (signature == _lastSignature) return;
    if (trimmed.isEmpty) {
      clear();
      return;
    }

    _lastSignature = signature;
    final currentToken = ++_activeSearchToken;
    _isSearching = true;
    notifyListeners();

    try {
      List<ProductSearchResult> products = const [];
      List<CategorySearchResult> categories = const [];

      if (!includeProducts && includeCategories) {
        categories = await _searchService.searchCategories(trimmed);
      } else if (categoryId != null) {
        products = await _searchService.searchProducts(
          trimmed,
          categoryId: categoryId,
        );
      } else {
        final productFuture = _searchService.searchProducts(trimmed);
        if (includeCategories) {
          final categoryFuture = _searchService.searchCategories(trimmed);
          final results = await Future.wait([productFuture, categoryFuture]);
          products = results[0] as List<ProductSearchResult>;
          categories = results[1] as List<CategorySearchResult>;
        } else {
          products = await productFuture;
        }
      }

      if (currentToken != _activeSearchToken) return;
      _productResults = products;
      _categoryResults = categoryId == null ? categories : const [];
    } catch (_) {
      if (currentToken != _activeSearchToken) return;
      _productResults = const [];
      _categoryResults = const [];
    } finally {
      if (currentToken == _activeSearchToken) {
        _isSearching = false;
        notifyListeners();
      }
    }
  }

  void clear() {
    _productResults = const [];
    _categoryResults = const [];
    _isSearching = false;
    _lastSignature = '';
    notifyListeners();
  }
}
