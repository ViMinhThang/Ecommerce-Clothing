import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../models/PageResponse.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  static const int defaultPageSize = 10;

  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<ProductView> _productViews = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _hasMore = true;
  String _searchQuery = '';
  int _currentCategoryId = 0;

  List<Product> get products => _products;
  List<ProductView> get productViews => _productViews;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _hasMore;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchProducts(refresh: true);
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (!_shouldProceedWithFetch(refresh)) return;

    _updateLoadingState(true, isRefresh: refresh);

    try {
      final response = await _productService.getProducts(
        name: _searchQuery,
        page: _currentPage,
        size: defaultPageSize,
      );

      _handlePageResponse(response, isRefresh: refresh, updateProducts: true);
    } catch (e, stack) {
      _logError('fetchProducts', e, stack);
    } finally {
      _updateLoadingState(false);
    }
  }

  Future<void> searchProducts(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchProducts(refresh: true);
  }

  Future<void> addProduct(Product product, {List<XFile>? images}) async {
    try {
      final multipartImages = await FileUtils.convertXFilesToMultipart(images);
      final newProduct = await _productService.createProduct(
        product,
        images: multipartImages,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (e, stack) {
      _logError('addProduct', e, stack);
    }
  }

  Future<void> updateProduct(
    Product product, {
    List<XFile>? images,
    List<int>? existingImageIds,
  }) async {
    try {
      final multipartImages = await FileUtils.convertXFilesToMultipart(images);
      final updatedProduct = await _productService.updateProduct(
        product.id,
        product,
        images: multipartImages,
        existingImageIds: existingImageIds,
      );
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e, stack) {
      _logError('updateProduct', e, stack);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e, stack) {
      _logError('deleteProduct', e, stack);
    }
  }

  Future<void> fetchProductsByCategory(
    int categoryId, {
    bool refresh = false,
  }) async {
    final isNewCategory = categoryId != _currentCategoryId;
    final shouldRefresh = refresh || isNewCategory;

    if (!_shouldProceedWithFetch(shouldRefresh)) return;

    if (shouldRefresh) {
      _resetPaginationState();
      _productViews = [];
      _currentCategoryId = categoryId;
    }

    _updateLoadingState(true, isRefresh: shouldRefresh);

    try {
      final response = await _productService.getProductsByCategory(
        categoryId,
        _currentPage,
        defaultPageSize,
      );

      _handlePageResponse(
        response,
        isRefresh: shouldRefresh,
        updateViews: true,
      );
    } catch (e, stack) {
      _logError('fetchProductsByCategory', e, stack);
    } finally {
      _updateLoadingState(false);
    }
  }

  void loadMore() => fetchProducts(refresh: false);

  void loadMoreByCategory(int categoryId) {
    fetchProductsByCategory(categoryId, refresh: false);
  }

  void prepareForCategory(int categoryId) {
    _currentCategoryId = categoryId;
    _products = [];
    _productViews = [];
    _resetPaginationState();
    _isLoading = true;
    _isMoreLoading = false;
    notifyListeners();
  }

  bool _shouldProceedWithFetch(bool isRefresh) {
    if (isRefresh) return true;
    if (_isLoading || _isMoreLoading) return false;
    if (!_hasMore) return false;
    return true;
  }

  void _updateLoadingState(bool loading, {bool isRefresh = false}) {
    if (loading) {
      if (isRefresh || (_products.isEmpty && _productViews.isEmpty)) {
        _isLoading = true;
        _isMoreLoading = false;
        if (isRefresh) _resetPaginationState();
      } else {
        _isLoading = false;
        _isMoreLoading = true;
      }
    } else {
      _isLoading = false;
      _isMoreLoading = false;
    }
    notifyListeners();
  }

  void _resetPaginationState() {
    _currentPage = 0;
    _totalPages = 0;
    _hasMore = true;
  }

  void _handlePageResponse<T>(
    PageResponse<T> response, {
    bool isRefresh = false,
    bool updateProducts = false,
    bool updateViews = false,
  }) {
    if (updateProducts && response.content is List<Product>) {
      final newItems = response.content as List<Product>;
      if (isRefresh) {
        _products = newItems;
      } else {
        _products.addAll(newItems);
      }
    }

    if (updateViews && response.content is List<ProductView>) {
      final newItems = response.content as List<ProductView>;
      if (isRefresh) {
        _productViews = newItems;
      } else {
        _productViews.addAll(newItems);
      }
    }

    _totalPages = response.totalPages;
    _currentPage++;
    _hasMore =
        response.content.length == defaultPageSize &&
        _currentPage < _totalPages;

    if (response.content.isEmpty) {
      _hasMore = false;
    }
  }

  void _logError(String operation, dynamic error, StackTrace stack) {
    debugPrint('Error in ProductProvider.$operation: $error');
    debugPrint(stack.toString());
  }
}
