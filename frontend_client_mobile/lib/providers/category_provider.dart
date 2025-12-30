import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;
  String _searchQuery = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchCategories();
    _isLoading = true;
  }

  Future<void> fetchCategories({bool refresh = true}) async {
    if (refresh) {
      _isLoading = true;
      _currentPage = 0;
      _hasMore = true;
      notifyListeners();
    } else {
      if (!_hasMore || _isFetchingMore) return;
      _isFetchingMore = true;
      notifyListeners();
    }

    try {
      final newCategories = await _categoryService.getCategories(
        name: _searchQuery.isEmpty ? null : _searchQuery,
        page: _currentPage,
        size: _pageSize,
      );

      if (refresh) {
        _categories = newCategories;
      } else {
        _categories.addAll(newCategories);
      }

      _hasMore = newCategories.length == _pageSize;
      if (_hasMore) _currentPage++;
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreCategories() async {
    await fetchCategories(refresh: false);
  }

  Future<void> searchCategories(String name) async {
    if (_searchQuery == name) return;
    _searchQuery = name;
    await fetchCategories();
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
      rethrow;
    }
  }

  Future<void> removeCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadCategoryImage(XFile imageFile) async {
    try {
      final multipartFile = await FileUtils.convertXFileToMultipart(imageFile);
      final imageUrl = await _categoryService.uploadCategoryImage(
        multipartFile!,
      );
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }
}
