import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchCategories();
    _isLoading = true;
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _categoryService.getCategories();
    } catch (e) {
      print(e);
      // Handle error
    }
    notifyListeners();
  }
}
