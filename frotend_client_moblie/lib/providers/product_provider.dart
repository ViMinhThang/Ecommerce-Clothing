import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _productService.getProducts();
    } catch (e, stack) {
      print(e);
      print(stack);
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
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
      // Handle error
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e, stack) {
      // Handle error
    }
  }
}
