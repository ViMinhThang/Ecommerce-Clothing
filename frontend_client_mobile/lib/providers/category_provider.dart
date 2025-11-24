import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  final int _pageSize = 10;
  String _searchQuery = '';
  bool _hasMore = true;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> initialize() async {
    if (_isLoading) return;
    await fetchCategories(refresh: true);
  }

  Future<void> fetchCategories({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _categories = [];
      _totalPages = 0;
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    } else {
      if (_isMoreLoading || !_hasMore && _categories.isNotEmpty) return;
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      // TODO: Update this when backend API supports pagination
      // For now, we'll simulate pagination with the existing getCategories()
      final allCategories = await _categoryService.getCategories();

      // Simulate pagination
      final startIndex = _currentPage * _pageSize;
      final endIndex = (startIndex + _pageSize).clamp(0, allCategories.length);

      if (startIndex < allCategories.length) {
        final pageCategories = allCategories.sublist(startIndex, endIndex);

        if (refresh) {
          _categories = pageCategories;
        } else {
          _categories.addAll(pageCategories);
        }

        _currentPage++;
        _totalPages = (allCategories.length / _pageSize).ceil();

        // Check if there's more data
        if (endIndex >= allCategories.length) {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }

      print(
        'Fetched categories: ${_categories.length}, Page: $_currentPage/$_totalPages',
      );
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    await fetchCategories(refresh: false);
  }

  Future<void> searchCategories(String query) async {
    if (_searchQuery == query) return;
    _searchQuery = query;
    // TODO: Implement search when backend API supports it
    await fetchCategories(refresh: true);
  }

  Future<Category> addCategory(Category category) async {
    try {
      final newCategory = await _categoryService.createCategory(category);
      _categories.insert(0, newCategory); // Add to beginning
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

  Future<String> uploadCategoryImage(XFile imageFile) async {
    try {
      final multipartFile = await FileUtils.convertXFileToMultipart(imageFile);
      final imageUrl = await _categoryService.uploadCategoryImage(
        multipartFile!,
      );
      return imageUrl;
    } catch (e) {
      print('Error uploading category image: $e');
      rethrow;
    }
  }
}
