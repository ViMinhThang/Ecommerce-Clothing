import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  final int _pageSize = 10;
  String _searchQuery = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _currentPage < _totalPages - 1;
  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchProducts();
    _isLoading = true;
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _products = [];
      _totalPages = 0;
      _isLoading = true;
      notifyListeners();
    } else {
      if (_isMoreLoading || !hasMore && _products.isNotEmpty) return;
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      final response = await _productService.getProducts(
        name: _searchQuery,
        page: _currentPage,
        size: _pageSize,
      );

      if (refresh) {
        _products = response.content;
      } else {
        _products.addAll(response.content);
      }

      _totalPages = response.totalPages;
      _currentPage++;

      print(
        'Fetched products: ${_products.length}, Page: $_currentPage/$_totalPages',
      );
    } catch (e, stack) {
      print(e);
      print(stack);
      // Handle error
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

  Future<void> addProduct(Product product, {File? image}) async {
    try {
      final newProduct = await _productService.createProduct(
        product,
        image: image,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (e, stack) {
      // Handle error
      print(e);
      print(stack);
    }
  }

  Future<void> updateProduct(Product product, {File? image}) async {
    try {
      final updatedProduct = await _productService.updateProduct(
        product.id,
        product,
        image: image,
      );
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e, stack) {
      print(e);
      print(stack);
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
}
