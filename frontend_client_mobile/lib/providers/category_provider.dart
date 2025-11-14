import 'dart:io';

import 'package:dio/dio.dart';
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
      print('Error fetching categories: $e');
    }
    notifyListeners();
  }

  Future<Category> addCategory(Category category) async {
    try {
      final newCategory = await _categoryService.createCategory(category);
      _categories.add(newCategory);
      notifyListeners();
      return newCategory;
    } catch (e) {
      print('Error adding category: $e');
      rethrow;
    }
  }

  Future<Category> updateCategory(Category category) async {
    try {
      final updatedCategory = await _categoryService.updateCategory(
        category.id as int,
        category,
      );
      final index = _categories.indexWhere((c) => c.id == updatedCategory.id);
      if (index != -1) {
        _categories[index] = updatedCategory;
        notifyListeners();
      }
      return updatedCategory;
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  Future<void> removeCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  Future<String> uploadCategoryImage(File imageFile) async {
    try {
      final imageUrl = await _categoryService.uploadCategoryImage(imageFile);
      return imageUrl;
    } catch (e) {
      print('Error uploading category image: $e');
      rethrow;
    }
  }
}
