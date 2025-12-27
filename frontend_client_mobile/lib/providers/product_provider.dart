import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<ProductView> _productViews = [];

  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 0;
  final int _pageSize = 10;
  String _searchQuery = '';

  bool _hasMore = true;

  int _currentCategoryId = 0;

  List<Product> get products => _products;
  List<ProductView> get productViews => _productViews;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;

  bool get hasMore => _hasMore;
  Future<void> initialize() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    await fetchProducts(refresh: true);
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _products = [];
      _isLoading = true;
      _isMoreLoading = false;
      _hasMore = true;
      notifyListeners();
    } else {
      if (_isMoreLoading || (!_hasMore && _products.isNotEmpty)) return;

      if (_products.isEmpty) {
        _isLoading = true;
        _isMoreLoading = false;
        notifyListeners();
      } else {
        _isMoreLoading = true;
        _isLoading = false;
        notifyListeners();
      }
    }

    try {
      final response = await _productService.getProducts(
        name: _searchQuery,
        page: _currentPage,
        size: _pageSize,
      );

      if (refresh || _products.isEmpty) {
        _products = response.content;
      } else {
        _products.addAll(response.content);
      }

      _currentPage++;

      if (response.content.length < _pageSize) {
        _hasMore = false;
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    await fetchProducts(refresh: false);
  }

  Future<void> searchProducts(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchProducts(refresh: true);
  }

  Future<void> addProduct(Product product, {XFile? image}) async {
    try {
      final newProduct = await _productService.createProduct(
        product,
        image: await FileUtils.convertXFileToMultipart(image),
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (e, stack) {
      // Handle error
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
  }

  Future<void> updateProduct(Product product, {XFile? image}) async {
    try {
      final updatedProduct = await _productService.updateProduct(
        product.id,
        product,
        image: await FileUtils.convertXFileToMultipart(image),
      );
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchProductsByCategory(
    int categoryId, {
    bool isRefresh = false,
  }) async {
    if (isRefresh || categoryId != _currentCategoryId) {
      _currentPage = 0;
      _productViews = [];
      _currentCategoryId = categoryId;
      _hasMore = true;

      _isLoading = true;
      _isMoreLoading = false;
      notifyListeners();
    } else {
      if (_isMoreLoading || !hasMore) {
        return;
      }

      _isLoading = false;
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      var res = await _productService.getProductsByCategory(
        categoryId,
        _currentPage,
        _pageSize,
      );

      if (res.content.isNotEmpty) {
        _productViews.addAll(res.content);

        _currentPage++;

        if (res.content.length < _pageSize) {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint("Lỗi load product: $e");
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  void loadMoreByCategory(int selectedCategoryId) {
    fetchProductsByCategory(selectedCategoryId, isRefresh: false);
  }

  void prepareForCategory(int categoryId) {
    _currentCategoryId = categoryId;
    _products = [];
    _productViews = [];
    _currentPage = 0;
    _hasMore = true;
    _isLoading = true;
    _isMoreLoading = false;
    notifyListeners();
  }
}
